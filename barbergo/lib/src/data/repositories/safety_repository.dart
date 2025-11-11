import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/safety_report.dart';

part 'safety_repository.g.dart';

/// Repository para Safety Center
@riverpod
SafetyRepository safetyRepository(SafetyRepositoryRef ref) {
  return SafetyRepository(FirebaseFirestore.instance);
}

class SafetyRepository {
  final FirebaseFirestore _firestore;

  SafetyRepository(this._firestore);

  CollectionReference get _reportsCollection => _firestore.collection('safety_reports');
  CollectionReference get _blocksCollection => _firestore.collection('user_blocks');
  CollectionReference get _emergencyContactsCollection => _firestore.collection('emergency_contacts');
  CollectionReference get _checkInsCollection => _firestore.collection('safety_checkins');
  CollectionReference get _settingsCollection => _firestore.collection('safety_settings');

  // ============================================
  // REPORTS
  // ============================================

  /// Criar relatório de segurança
  Future<String> createReport(SafetyReport report) async {
    final docRef = await _reportsCollection.add(report.toMap());
    return docRef.id;
  }

  /// Obter relatório por ID
  Future<SafetyReport?> getReport(String reportId) async {
    final doc = await _reportsCollection.doc(reportId).get();
    if (!doc.exists) return null;

    return SafetyReportMapper.fromMap({...doc.data() as Map<String, dynamic>, 'reportId': doc.id});
  }

  /// Obter relatórios feitos por um usuário
  Future<List<SafetyReport>> getReportsSubmitted(String userId) async {
    final snapshot = await _reportsCollection
        .where('reporterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SafetyReportMapper.fromMap({...doc.data() as Map<String, dynamic>, 'reportId': doc.id}))
        .toList();
  }

  /// Obter relatórios recebidos por um usuário
  Future<List<SafetyReport>> getReportsReceived(String userId) async {
    final snapshot = await _reportsCollection
        .where('reportedUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SafetyReportMapper.fromMap({...doc.data() as Map<String, dynamic>, 'reportId': doc.id}))
        .toList();
  }

  /// Obter relatórios pendentes (admin)
  Future<List<SafetyReport>> getPendingReports({int limit = 50}) async {
    final snapshot = await _reportsCollection
        .where('status', whereIn: [ReportStatus.pending.name, ReportStatus.underReview.name])
        .orderBy('severity', descending: true)
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => SafetyReportMapper.fromMap({...doc.data() as Map<String, dynamic>, 'reportId': doc.id}))
        .toList();
  }

  /// Atualizar status do relatório
  Future<void> updateReportStatus({
    required String reportId,
    required ReportStatus status,
    String? reviewedBy,
    ReportAction? action,
    String? reviewNotes,
    ReportSeverity? severity,
  }) async {
    final updateData = <String, dynamic>{'status': status.name, 'reviewedAt': FieldValue.serverTimestamp()};

    if (reviewedBy != null) updateData['reviewedBy'] = reviewedBy;
    if (action != null) updateData['action'] = action.name;
    if (reviewNotes != null) updateData['reviewNotes'] = reviewNotes;
    if (severity != null) updateData['severity'] = severity.name;

    await _reportsCollection.doc(reportId).update(updateData);
  }

  // ============================================
  // BLOCKS
  // ============================================

  /// Bloquear usuário
  Future<String> blockUser(UserBlock block) async {
    final docRef = await _blocksCollection.add(block.toMap());
    return docRef.id;
  }

  /// Desbloquear usuário
  Future<void> unblockUser(String blockerId, String blockedUserId) async {
    final snapshot = await _blocksCollection
        .where('blockerId', isEqualTo: blockerId)
        .where('blockedUserId', isEqualTo: blockedUserId)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// Verificar se usuário está bloqueado
  Future<bool> isUserBlocked(String blockerId, String blockedUserId) async {
    final snapshot = await _blocksCollection
        .where('blockerId', isEqualTo: blockerId)
        .where('blockedUserId', isEqualTo: blockedUserId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// Obter todos os bloqueios de um usuário
  Future<List<UserBlock>> getUserBlocks(String blockerId) async {
    final snapshot = await _blocksCollection
        .where('blockerId', isEqualTo: blockerId)
        .orderBy('blockedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => UserBlockMapper.fromMap({...doc.data() as Map<String, dynamic>, 'blockId': doc.id}))
        .toList();
  }

  /// Obter IDs dos usuários bloqueados
  Future<Set<String>> getBlockedUserIds(String blockerId) async {
    final blocks = await getUserBlocks(blockerId);
    return blocks.map((b) => b.blockedUserId).toSet();
  }

  // ============================================
  // EMERGENCY CONTACTS
  // ============================================

  /// Adicionar contato de emergência
  Future<String> addEmergencyContact(EmergencyContact contact) async {
    final docRef = await _emergencyContactsCollection.add(contact.toMap());
    return docRef.id;
  }

  /// Obter contatos de emergência do usuário
  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    final snapshot = await _emergencyContactsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('addedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => EmergencyContactMapper.fromMap({...doc.data() as Map<String, dynamic>, 'contactId': doc.id}))
        .toList();
  }

  /// Atualizar contato de emergência
  Future<void> updateEmergencyContact({required String contactId, bool? isEnabled, DateTime? lastNotifiedAt}) async {
    final updateData = <String, dynamic>{};
    if (isEnabled != null) updateData['isEnabled'] = isEnabled;
    if (lastNotifiedAt != null) updateData['lastNotifiedAt'] = Timestamp.fromDate(lastNotifiedAt);

    await _emergencyContactsCollection.doc(contactId).update(updateData);
  }

  /// Deletar contato de emergência
  Future<void> deleteEmergencyContact(String contactId) async {
    await _emergencyContactsCollection.doc(contactId).delete();
  }

  // ============================================
  // CHECK-INS
  // ============================================

  /// Criar check-in de segurança
  Future<String> createCheckIn(SafetyCheckIn checkIn) async {
    final docRef = await _checkInsCollection.add(checkIn.toMap());
    return docRef.id;
  }

  /// Completar check-in
  Future<void> completeCheckIn(String checkInId) async {
    await _checkInsCollection.doc(checkInId).update({
      'checkedInAt': FieldValue.serverTimestamp(),
      'status': CheckInStatus.completed.name,
    });
  }

  /// Marcar check-in como emergência
  Future<void> markCheckInAsEmergency({required String checkInId, String? emergencyMessage}) async {
    await _checkInsCollection.doc(checkInId).update({
      'isEmergency': true,
      'status': CheckInStatus.emergency.name,
      if (emergencyMessage != null) 'emergencyMessage': emergencyMessage,
    });
  }

  /// Obter check-ins do usuário
  Future<List<SafetyCheckIn>> getUserCheckIns(String userId) async {
    final snapshot = await _checkInsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('scheduledTime', descending: true)
        .limit(50)
        .get();

    return snapshot.docs
        .map((doc) => SafetyCheckInMapper.fromMap({...doc.data() as Map<String, dynamic>, 'checkInId': doc.id}))
        .toList();
  }

  /// Obter check-ins pendentes
  Future<List<SafetyCheckIn>> getPendingCheckIns(String userId) async {
    final snapshot = await _checkInsCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: CheckInStatus.pending.name)
        .orderBy('scheduledTime', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => SafetyCheckInMapper.fromMap({...doc.data() as Map<String, dynamic>, 'checkInId': doc.id}))
        .toList();
  }

  // ============================================
  // SETTINGS
  // ============================================

  /// Salvar configurações de segurança
  Future<void> saveSettings(SafetySettings settings) async {
    await _settingsCollection.doc(settings.userId).set(settings.toMap());
  }

  /// Obter configurações de segurança
  Future<SafetySettings?> getSettings(String userId) async {
    final doc = await _settingsCollection.doc(userId).get();
    if (!doc.exists) return null;

    return SafetySettingsMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  // ============================================
  // STATISTICS
  // ============================================

  /// Obter estatísticas de segurança do usuário
  Future<SafetyStats> getUserSafetyStats(String userId) async {
    final submitted = await getReportsSubmitted(userId);
    final received = await getReportsReceived(userId);
    final blocks = await getUserBlocks(userId);
    final contacts = await getEmergencyContacts(userId);
    final checkIns = await getUserCheckIns(userId);

    final completed = checkIns.where((c) => c.status == CheckInStatus.completed).length;
    final missed = checkIns.where((c) => c.status == CheckInStatus.missed).length;

    final safetyScore = _calculateSafetyScore(
      reportsReceived: received.length,
      checkInsCompleted: completed,
      checkInsMissed: missed,
      emergencyContacts: contacts.length,
    );

    return SafetyStats(
      totalReportsSubmitted: submitted.length,
      totalReportsReceived: received.length,
      activeBlocks: blocks.length,
      emergencyContactsCount: contacts.where((c) => c.isEnabled).length,
      checkInsCompleted: completed,
      checkInsMissed: missed,
      lastReportDate: submitted.isNotEmpty ? submitted.first.createdAt : null,
      safetyScore: safetyScore,
    );
  }

  double _calculateSafetyScore({
    required int reportsReceived,
    required int checkInsCompleted,
    required int checkInsMissed,
    required int emergencyContacts,
  }) {
    var score = 100.0;

    // Penalizar por relatórios recebidos
    score -= reportsReceived * 5;

    // Penalizar por check-ins perdidos
    score -= checkInsMissed * 2;

    // Bonificar por check-ins completados
    score += checkInsCompleted * 0.5;

    // Bonificar por ter contatos de emergência
    score += emergencyContacts * 3;

    return score.clamp(0, 100);
  }

  /// Stream de relatórios pendentes (admin)
  Stream<List<SafetyReport>> watchPendingReports() {
    return _reportsCollection
        .where('status', whereIn: [ReportStatus.pending.name, ReportStatus.underReview.name])
        .orderBy('severity', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SafetyReportMapper.fromMap({...doc.data() as Map<String, dynamic>, 'reportId': doc.id}))
              .toList(),
        );
  }
}
