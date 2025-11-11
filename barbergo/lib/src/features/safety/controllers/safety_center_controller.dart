import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/safety_report.dart';
import '../../../data/repositories/safety_repository.dart';
import '../../profile/controllers/profile_controller.dart';

part 'safety_center_controller.g.dart';

/// Controller para Safety Center (Phase 3)
@riverpod
class SafetyCenterController extends _$SafetyCenterController {
  @override
  FutureOr<bool> build() async {
    // Inicializar
  }
    return true;
  }

  // ============================================
  // REPORTS
  // ============================================

  /// Criar relatório de segurança
  Future<String> createReport({
    required String reportedUserId,
    required ReportReason reason,
    String? customReason,
    List<String>? evidenceUrls,
  }) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      // Determinar severidade automaticamente
      final severity = _calculateSeverity(reason);

      final report = SafetyReport(
        reportId: '',
        reporterId: currentUser.userId,
        reportedUserId: reportedUserId,
        reason: reason,
        customReason: customReason,
        evidenceUrls: evidenceUrls ?? [],
        createdAt: DateTime.now(),
        status: ReportStatus.pending,
        severity: severity,
      );

      final repo = ref.read(safetyRepositoryProvider);
      final reportId = await repo.createReport(report);

      // Se for crítico, escalar automaticamente
      if (severity == ReportSeverity.critical) {
        await repo.updateReportStatus(reportId: reportId, status: ReportStatus.escalated, severity: severity);
      }

      state = const AsyncData(null);
      return reportId;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter relatórios do usuário
  Future<List<SafetyReport>> getMyReports() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(safetyRepositoryProvider);
    return repo.getReportsSubmitted(currentUser.userId);
  }

  // ============================================
  // BLOCKS
  // ============================================

  /// Bloquear usuário
  Future<void> blockUser({required String blockedUserId, String? reason}) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final block = UserBlock(
        blockId: '',
        blockerId: currentUser.userId,
        blockedUserId: blockedUserId,
        blockedAt: DateTime.now(),
        reason: reason,
      );

      final repo = ref.read(safetyRepositoryProvider);
      await repo.blockUser(block);

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Desbloquear usuário
  Future<void> unblockUser(String blockedUserId) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final repo = ref.read(safetyRepositoryProvider);
      await repo.unblockUser(currentUser.userId, blockedUserId);

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Verificar se usuário está bloqueado
  Future<bool> isBlocked(String userId) async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return false;

    final repo = ref.read(safetyRepositoryProvider);
    return repo.isUserBlocked(currentUser.userId, userId);
  }

  /// Obter lista de bloqueados
  Future<List<UserBlock>> getBlockedUsers() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(safetyRepositoryProvider);
    return repo.getUserBlocks(currentUser.userId);
  }

  // ============================================
  // EMERGENCY CONTACTS
  // ============================================

  /// Adicionar contato de emergência
  Future<String> addEmergencyContact({required String name, required String phoneNumber, String? email}) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final contact = EmergencyContact(
        contactId: '',
        userId: currentUser.userId,
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        addedAt: DateTime.now(),
      );

      final repo = ref.read(safetyRepositoryProvider);
      final contactId = await repo.addEmergencyContact(contact);

      state = const AsyncData(null);
      return contactId;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter contatos de emergência
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return [];

    final repo = ref.read(safetyRepositoryProvider);
    return repo.getEmergencyContacts(currentUser.userId);
  }

  /// Notificar contatos de emergência
  Future<void> notifyEmergencyContacts({required String message, String? location}) async {
    state = const AsyncLoading();

    try {
      final contacts = await getEmergencyContacts();
      final activeContacts = contacts.where((c) => c.isEnabled).toList();

      // TODO: Enviar SMS/Email real
      for (final contact in activeContacts) {
        print('EMERGÊNCIA: Enviando para ${contact.name} (${contact.phoneNumber})');
        print('Mensagem: $message');
        if (location != null) print('Localização: $location');

        // Atualizar lastNotifiedAt
        final repo = ref.read(safetyRepositoryProvider);
        await repo.updateEmergencyContact(contactId: contact.contactId, lastNotifiedAt: DateTime.now());
      }

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  // ============================================
  // CHECK-INS
  // ============================================

  /// Criar check-in de segurança
  Future<String> scheduleCheckIn({required DateTime scheduledTime, String? location, String? datePartnerUserId}) async {
    state = const AsyncLoading();

    try {
      final currentUser = ref.read(currentUserProfileProvider).value;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final checkIn = SafetyCheckIn(
        checkInId: '',
        userId: currentUser.userId,
        scheduledTime: scheduledTime,
        location: location,
        datePartnerUserId: datePartnerUserId,
      );

      final repo = ref.read(safetyRepositoryProvider);
      final checkInId = await repo.createCheckIn(checkIn);

      state = const AsyncData(null);
      return checkInId;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Completar check-in
  Future<void> completeCheckIn(String checkInId) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(safetyRepositoryProvider);
      await repo.completeCheckIn(checkInId);

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Acionar emergência
  Future<void> triggerEmergency({required String checkInId, String? customMessage, String? location}) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(safetyRepositoryProvider);

      // Marcar check-in como emergência
      await repo.markCheckInAsEmergency(checkInId: checkInId, emergencyMessage: customMessage);

      // Notificar contatos de emergência
      final message = customMessage ?? 'Emergência! Preciso de ajuda.';
      await notifyEmergencyContacts(message: message, location: location);

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  // ============================================
  // SETTINGS
  // ============================================

  /// Salvar configurações de segurança
  Future<void> saveSettings(SafetySettings settings) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(safetyRepositoryProvider);
      await repo.saveSettings(settings);

      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  /// Obter configurações
  Future<SafetySettings?> getSettings() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) return null;

    final repo = ref.read(safetyRepositoryProvider);
    return repo.getSettings(currentUser.userId);
  }

  // ============================================
  // STATISTICS & HELPERS
  // ============================================

  /// Obter estatísticas de segurança
  Future<SafetyStats> getMyStats() async {
    final currentUser = ref.read(currentUserProfileProvider).value;
    if (currentUser == null) {
      return const SafetyStats(
        totalReportsSubmitted: 0,
        totalReportsReceived: 0,
        activeBlocks: 0,
        emergencyContactsCount: 0,
        checkInsCompleted: 0,
        checkInsMissed: 0,
        safetyScore: 100,
      );
    }

    final repo = ref.read(safetyRepositoryProvider);
    return repo.getUserSafetyStats(currentUser.userId);
  }

  /// Obter dicas de segurança
  List<SafetyTip> getSafetyTips() {
    return [
      const SafetyTip(
        tipId: '1',
        title: 'Encontre em local público',
        description: 'Sempre marque o primeiro encontro em um local público e movimentado.',
        category: SafetyTipCategory.beforeMeeting,
        priority: 10,
      ),
      const SafetyTip(
        tipId: '2',
        title: 'Conte para alguém',
        description: 'Informe um amigo ou familiar sobre seus planos de encontro.',
        category: SafetyTipCategory.beforeMeeting,
        priority: 9,
      ),
      const SafetyTip(
        tipId: '3',
        title: 'Transporte próprio',
        description: 'Vá e volte com seu próprio transporte na primeira vez.',
        category: SafetyTipCategory.duringDate,
        priority: 8,
      ),
      const SafetyTip(
        tipId: '4',
        title: 'Não compartilhe endereço',
        description: 'Evite compartilhar seu endereço ou local de trabalho inicialmente.',
        category: SafetyTipCategory.personalInfo,
        priority: 9,
      ),
      const SafetyTip(
        tipId: '5',
        title: 'Confie no seu instinto',
        description: 'Se algo não parecer certo, encerre o encontro educadamente.',
        category: SafetyTipCategory.redFlags,
        priority: 10,
      ),
      const SafetyTip(
        tipId: '6',
        title: 'Use o Safety Check-in',
        description: 'Configure um check-in de segurança durante o encontro.',
        category: SafetyTipCategory.duringDate,
        priority: 7,
      ),
    ];
  }

  // ============================================
  // INTERNAL HELPERS
  // ============================================

  ReportSeverity _calculateSeverity(ReportReason reason) {
    switch (reason) {
      case ReportReason.threatPhysicalHarm:
      case ReportReason.violence:
      case ReportReason.stalking:
        return ReportSeverity.critical;

      case ReportReason.harassment:
      case ReportReason.hateSpeech:
      case ReportReason.sexualContent:
        return ReportSeverity.high;

      case ReportReason.inappropriatePhotos:
      case ReportReason.inappropriateContent:
      case ReportReason.fakeProfile:
        return ReportSeverity.medium;

      case ReportReason.spam:
      case ReportReason.scam:
      case ReportReason.impersonation:
      case ReportReason.underage:
      case ReportReason.other:
        return ReportSeverity.low;
    }
  }
}

/// Provider para bloqueados do usuário atual
@riverpod
Future<Set<String>> blockedUserIds(BlockedUserIdsRef ref) async {
  final currentUser = ref.watch(currentUserProfileProvider).value;
  if (currentUser == null) return {};

  final repo = ref.watch(safetyRepositoryProvider);
  return repo.getBlockedUserIds(currentUser.userId);
}

/// Provider para estatísticas de segurança
@riverpod
Future<SafetyStats> currentUserSafetyStats(CurrentUserSafetyStatsRef ref) async {
  final controller = ref.watch(safetyCenterControllerProvider.notifier);
  return controller.getMyStats();
}

/// Provider para check-ins pendentes
@riverpod
Future<List<SafetyCheckIn>> pendingCheckIns(PendingCheckInsRef ref) async {
  final currentUser = ref.watch(currentUserProfileProvider).value;
  if (currentUser == null) return [];

  final repo = ref.watch(safetyRepositoryProvider);
  return repo.getPendingCheckIns(currentUser.userId);
}

