import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/identity_verification.dart';

part 'identity_verification_repository.g.dart';

/// Repository para Identity Verification
@riverpod
IdentityVerificationRepository identityVerificationRepository(IdentityVerificationRepositoryRef ref) {
  return IdentityVerificationRepository(FirebaseFirestore.instance);
}

class IdentityVerificationRepository {
  final FirebaseFirestore _firestore;

  IdentityVerificationRepository(this._firestore);

  CollectionReference get _verificationsCollection => _firestore.collection('identity_verifications');

  /// Submeter nova verificação
  Future<String> submitVerification(IdentityVerification verification) async {
    final docRef = await _verificationsCollection.add(verification.toMap());
    return docRef.id;
  }

  /// Obter verificação por ID
  Future<IdentityVerification?> getVerification(String verificationId) async {
    final doc = await _verificationsCollection.doc(verificationId).get();
    if (!doc.exists) return null;

    return IdentityVerificationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'verificationId': doc.id});
  }

  /// Obter todas as verificações de um usuário
  Future<List<IdentityVerification>> getUserVerifications(String userId) async {
    final snapshot = await _verificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('submittedAt', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              IdentityVerificationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'verificationId': doc.id}),
        )
        .toList();
  }

  /// Obter verificação ativa (aprovada e não expirada)
  Future<IdentityVerification?> getActiveVerification(String userId) async {
    final snapshot = await _verificationsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: VerificationStatus.approved.name)
        .orderBy('reviewedAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final verification = IdentityVerificationMapper.fromMap({
      ...snapshot.docs.first.data() as Map<String, dynamic>,
      'verificationId': snapshot.docs.first.id,
    });

    // Verificar se não está expirado
    if (verification.badge?.isExpired ?? true) return null;

    return verification;
  }

  /// Obter verificações pendentes (para admins)
  Future<List<IdentityVerification>> getPendingVerifications({int limit = 50}) async {
    final snapshot = await _verificationsCollection
        .where('status', whereIn: [VerificationStatus.pending.name, VerificationStatus.underReview.name])
        .orderBy('submittedAt', descending: false)
        .limit(limit)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              IdentityVerificationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'verificationId': doc.id}),
        )
        .toList();
  }

  /// Atualizar status da verificação
  Future<void> updateVerificationStatus({
    required String verificationId,
    required VerificationStatus status,
    String? reviewedBy,
    String? rejectionReason,
    VerificationBadge? badge,
  }) async {
    final updateData = <String, dynamic>{'status': status.name, 'reviewedAt': FieldValue.serverTimestamp()};

    if (reviewedBy != null) updateData['reviewedBy'] = reviewedBy;
    if (rejectionReason != null) updateData['rejectionReason'] = rejectionReason;
    if (badge != null) updateData['badge'] = badge.toMap();

    await _verificationsCollection.doc(verificationId).update(updateData);
  }

  /// Adicionar documento à verificação
  Future<void> addDocument({required String verificationId, required VerificationDocument document}) async {
    await _verificationsCollection.doc(verificationId).update({
      'documents': FieldValue.arrayUnion([document.toMap()]),
    });
  }

  /// Incrementar contador de tentativas
  Future<void> incrementAttemptCount({required String verificationId, DateTime? nextAttemptAllowedAt}) async {
    await _verificationsCollection.doc(verificationId).update({
      'attemptCount': FieldValue.increment(1),
      if (nextAttemptAllowedAt != null) 'nextAttemptAllowedAt': Timestamp.fromDate(nextAttemptAllowedAt),
    });
  }

  /// Obter estatísticas de verificação do usuário
  Future<VerificationStats> getUserVerificationStats(String userId) async {
    final verifications = await getUserVerifications(userId);

    final approved = verifications.where((v) => v.status == VerificationStatus.approved).length;
    final rejected = verifications.where((v) => v.status == VerificationStatus.rejected).length;
    final pending = verifications
        .where((v) => v.status == VerificationStatus.pending || v.status == VerificationStatus.underReview)
        .length;

    final byType = <VerificationType, int>{};
    for (final v in verifications) {
      byType[v.type] = (byType[v.type] ?? 0) + 1;
    }

    final lastVerified =
        verifications
            .where((v) => v.status == VerificationStatus.approved)
            .map((v) => v.reviewedAt ?? v.submittedAt)
            .fold<DateTime?>(null, (prev, date) => prev == null || date.isAfter(prev) ? date : prev) ??
        DateTime.now();

    return VerificationStats(
      totalVerifications: verifications.length,
      approvedCount: approved,
      rejectedCount: rejected,
      pendingCount: pending,
      approvalRate: verifications.isEmpty ? 0 : approved / verifications.length,
      verificationsByType: byType,
      lastVerifiedAt: lastVerified,
    );
  }

  /// Stream de verificações do usuário
  Stream<List<IdentityVerification>> watchUserVerifications(String userId) {
    return _verificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => IdentityVerificationMapper.fromMap({
                  ...doc.data() as Map<String, dynamic>,
                  'verificationId': doc.id,
                }),
              )
              .toList(),
        );
  }

  /// Verificar se usuário tem badge ativo
  Future<VerificationBadge?> getActiveBadge(String userId) async {
    final verification = await getActiveVerification(userId);
    return verification?.badge;
  }

  /// Deletar verificação (GDPR compliance)
  Future<void> deleteVerification(String verificationId) async {
    await _verificationsCollection.doc(verificationId).delete();
  }

  /// Deletar todas as verificações de um usuário
  Future<void> deleteUserVerifications(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _verificationsCollection.where('userId', isEqualTo: userId).get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
