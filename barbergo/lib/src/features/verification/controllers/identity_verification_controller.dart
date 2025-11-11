import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/identity_verification.dart';
import '../../../data/repositories/identity_verification_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'identity_verification_controller.g.dart';

/// Controller para Identity Verification (Phase 3)
@riverpod
class IdentityVerificationController extends _$IdentityVerificationController {
  @override
  FutureOr<bool> build() {
    return true; // Inicializar
  }

  /// Iniciar processo de verificação
  Future<VerificationResult> startVerification({
    required VerificationType type,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(identityVerificationRepositoryProvider);

      // Verificar se já existe verificação pendente
      final existing = await repo.getUserVerifications(currentUser.userId);
      final pending = existing
          .where(
            (v) =>
                v.type == type &&
                (v.status == VerificationStatus.pending || v.status == VerificationStatus.underReview),
          )
          .firstOrNull;

      if (pending != null) {
        state = const AsyncData(null);
        return VerificationResult(
          success: false,
          message: 'Já existe uma verificação deste tipo em análise',
          verificationId: pending.verificationId,
          status: pending.status,
        );
      }

      // Criar nova verificação
      final verification = IdentityVerification(
        verificationId: '', // Será gerado pelo Firestore
        userId: currentUser.userId,
        type: type,
        status: VerificationStatus.pending,
        submittedAt: DateTime.now(),
        documents: [],
      );

      final verificationId = await repo.submitVerification(verification);

      state = const AsyncData(null);
      return VerificationResult(
        success: true,
        verificationId: verificationId,
        status: VerificationStatus.pending,
        message: 'Verificação iniciada com sucesso',
        nextSteps: _getNextSteps(type, []),
      );
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return VerificationResult(success: false, message: 'Erro ao iniciar verificação: $e');
    }
  }

  /// Fazer upload de documento de verificação
  Future<VerificationResult> uploadDocument({
    required String verificationId,
    required File file,
    required DocumentType documentType,
    Map<String, dynamic>? metadata,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(identityVerificationRepositoryProvider);

      // TODO: Upload real para Firebase Storage
      final fileUrl =
          'gs://bucket/verifications/$verificationId/${documentType.name}_${DateTime.now().millisecondsSinceEpoch}';

      final document = VerificationDocument(
        documentId: DateTime.now().millisecondsSinceEpoch.toString(),
        type: documentType,
        fileUrl: fileUrl,
        uploadedAt: DateTime.now(),
        metadata: metadata ?? {},
      );

      await repo.addDocument(verificationId: verificationId, document: document);

      // Atualizar status para em análise
      await repo.updateVerificationStatus(verificationId: verificationId, status: VerificationStatus.underReview);

      state = const AsyncData(null);
      return VerificationResult(
        success: true,
        verificationId: verificationId,
        status: VerificationStatus.underReview,
        message: 'Documento enviado com sucesso',
      );
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return VerificationResult(success: false, message: 'Erro ao enviar documento: $e');
    }
  }

  /// Aprovar verificação (admin only)
  Future<void> approveVerification({required String verificationId, required String reviewerId}) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(identityVerificationRepositoryProvider);
      final verification = await repo.getVerification(verificationId);

      if (verification == null) {
        throw Exception('Verificação não encontrada');
      }

      // Calcular badge baseado nas verificações do usuário
      final allVerifications = await repo.getUserVerifications(verification.userId);
      final approvedTypes = allVerifications
          .where((v) => v.status == VerificationStatus.approved)
          .map((v) => v.type)
          .toSet();
      approvedTypes.add(verification.type);

      final badge = _generateBadge(approvedTypes);

      await repo.updateVerificationStatus(
        verificationId: verificationId,
        status: VerificationStatus.approved,
        reviewedBy: reviewerId,
        badge: badge,
      );

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Rejeitar verificação (admin only)
  Future<void> rejectVerification({
    required String verificationId,
    required String reviewerId,
    required String reason,
  }) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(identityVerificationRepositoryProvider);

      await repo.updateVerificationStatus(
        verificationId: verificationId,
        status: VerificationStatus.rejected,
        reviewedBy: reviewerId,
        rejectionReason: reason,
      );

      // Incrementar tentativas e definir cooldown
      await repo.incrementAttemptCount(
        verificationId: verificationId,
        nextAttemptAllowedAt: DateTime.now().add(const Duration(hours: 24)),
      );

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter badge ativo do usuário
  Future<VerificationBadge?> getUserBadge(String userId) async {
    final repo = ref.read(identityVerificationRepositoryProvider);
    return repo.getActiveBadge(userId);
  }

  /// Obter estatísticas de verificação
  Future<VerificationStats> getUserStats(String userId) async {
    final repo = ref.read(identityVerificationRepositoryProvider);
    return repo.getUserVerificationStats(userId);
  }

  /// Verificar se usuário está verificado
  Future<bool> isUserVerified(String userId) async {
    final badge = await getUserBadge(userId);
    return badge != null && !badge.isExpired;
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  VerificationBadge _generateBadge(Set<VerificationType> completedVerifications) {
    final level = _calculateBadgeLevel(completedVerifications);
    final trustScore = _calculateTrustScore(completedVerifications);

    return VerificationBadge(
      badgeId: DateTime.now().millisecondsSinceEpoch.toString(),
      level: level,
      issuedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 365)),
      verificationsCompleted: completedVerifications,
      trustScore: trustScore,
    );
  }

  BadgeLevel _calculateBadgeLevel(Set<VerificationType> verifications) {
    final count = verifications.length;

    if (count >= 4) return BadgeLevel.elite;
    if (count >= 3) return BadgeLevel.premium;
    if (count >= 2) return BadgeLevel.verified;
    return BadgeLevel.basic;
  }

  int _calculateTrustScore(Set<VerificationType> verifications) {
    // Base score
    var score = 40;

    // Adicionar pontos por cada verificação
    final scores = {
      VerificationType.emailVerification: 10,
      VerificationType.phoneVerification: 10,
      VerificationType.photoVerification: 15,
      VerificationType.documentVerification: 20,
      VerificationType.videoVerification: 20,
      VerificationType.socialMediaLink: 15,
    };

    for (final type in verifications) {
      score += scores[type] ?? 0;
    }

    return score.clamp(0, 100);
  }

  List<String> _getNextSteps(VerificationType completedType, List<VerificationType> existingTypes) {
    final completed = {...existingTypes, completedType};
    final remaining = VerificationType.values.where((t) => !completed.contains(t)).toList();

    if (remaining.isEmpty) {
      return ['Você completou todas as verificações disponíveis! 🎉'];
    }

    // Sugerir próximas verificações em ordem de importância
    final suggestions = <String>[];

    if (!completed.contains(VerificationType.documentVerification)) {
      suggestions.add('Verifique seu documento de identidade para aumentar sua confiança');
    }

    if (!completed.contains(VerificationType.videoVerification)) {
      suggestions.add('Adicione uma verificação por vídeo para o badge Premium');
    }

    if (!completed.contains(VerificationType.socialMediaLink)) {
      suggestions.add('Conecte suas redes sociais para validação adicional');
    }

    return suggestions;
  }
}

/// Provider para verificações do usuário
@riverpod
Stream<List<IdentityVerification>> userVerifications(UserVerificationsRef ref, String userId) {
  final repo = ref.watch(identityVerificationRepositoryProvider);
  return repo.watchUserVerifications(userId);
}

/// Provider para badge do usuário atual
@riverpod
Future<VerificationBadge?> currentUserBadge(CurrentUserBadgeRef ref) async {
  final currentUser = ref.watch(currentUserProfileProvider).value;
  if (currentUser == null) return null;

  final repo = ref.watch(identityVerificationRepositoryProvider);
  return repo.getActiveBadge(currentUser.userId);
}

/// Provider para verificações pendentes (admin)
@riverpod
Future<List<IdentityVerification>> pendingVerifications(PendingVerificationsRef ref) async {
  final repo = ref.watch(identityVerificationRepositoryProvider);
  return repo.getPendingVerifications();
}
