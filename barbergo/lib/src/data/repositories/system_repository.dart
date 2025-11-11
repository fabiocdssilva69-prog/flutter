import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/entities/system_entities.dart';

part 'system_repository.g.dart';

/// Repository para Settings, Notifications, Support, etc
@riverpod
SystemRepository systemRepository(SystemRepositoryRef ref) {
  return SystemRepository(FirebaseFirestore.instance);
}

class SystemRepository {
  final FirebaseFirestore _firestore;

  SystemRepository(this._firestore);

  CollectionReference get _settingsCollection => _firestore.collection('user_settings');
  CollectionReference get _notificationsCollection => _firestore.collection('notifications');
  CollectionReference get _supportTicketsCollection => _firestore.collection('support_tickets');
  CollectionReference get _faqCollection => _firestore.collection('faq');
  CollectionReference get _featureFlagsCollection => _firestore.collection('feature_flags');
  CollectionReference get _onboardingCollection => _firestore.collection('onboarding_progress');
  CollectionReference get _conversationsCollection => _firestore.collection('conversations');
  CollectionReference get _messagesCollection => _firestore.collection('messages');
  CollectionReference get _adminActionsCollection => _firestore.collection('admin_actions');

  // ============================================
  // SETTINGS
  // ============================================

  Future<AppSettings> getUserSettings(String userId) async {
    final doc = await _settingsCollection.doc(userId).get();

    if (!doc.exists) {
      // Criar configurações padrão
      final defaultSettings = AppSettings(
        userId: userId,
        notifications: const NotificationSettings(),
        privacy: const PrivacySettings(),
        discovery: const DiscoverySettings(),
        communication: const CommunicationSettings(),
        appearance: const AppearanceSettings(),
        accessibility: const AccessibilitySettings(),
        security: const SecuritySettings(),
        updatedAt: DateTime.now(),
      );

      await _settingsCollection.doc(userId).set(defaultSettings.toMap());
      return defaultSettings;
    }

    return AppSettingsMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateSettings(String userId, Map<String, dynamic> updates) async {
    await _settingsCollection.doc(userId).update({...updates, 'updatedAt': FieldValue.serverTimestamp()});
  }

  // ============================================
  // NOTIFICATIONS
  // ============================================

  Future<List<AppNotification>> getUserNotifications(String userId, {int limit = 50}) async {
    final snapshot = await _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => AppNotificationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'notificationId': doc.id}))
        .toList();
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    final snapshot = await _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _notificationsCollection.doc(notificationId).update({'isRead': true, 'readAt': FieldValue.serverTimestamp()});
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true, 'readAt': FieldValue.serverTimestamp()});
    }

    await batch.commit();
  }

  Future<String> createNotification(AppNotification notification) async {
    final docRef = await _notificationsCollection.add(notification.toMap());
    return docRef.id;
  }

  // ============================================
  // SUPPORT
  // ============================================

  Future<String> createSupportTicket(SupportTicket ticket) async {
    final docRef = await _supportTicketsCollection.add(ticket.toMap());
    return docRef.id;
  }

  Future<List<SupportTicket>> getUserTickets(String userId) async {
    final snapshot = await _supportTicketsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SupportTicketMapper.fromMap({...doc.data() as Map<String, dynamic>, 'ticketId': doc.id}))
        .toList();
  }

  Future<void> addMessageToTicket(String ticketId, SupportMessage message) async {
    await _supportTicketsCollection.doc(ticketId).update({
      'messages': FieldValue.arrayUnion([message.toMap()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTicketStatus(String ticketId, TicketStatus status) async {
    final updates = {'status': status.name, 'updatedAt': FieldValue.serverTimestamp()};

    if (status == TicketStatus.resolved || status == TicketStatus.closed) {
      updates['resolvedAt'] = FieldValue.serverTimestamp();
    }

    await _supportTicketsCollection.doc(ticketId).update(updates);
  }

  // ============================================
  // FAQ
  // ============================================

  Future<List<FAQItem>> getFAQs({FAQCategory? category}) async {
    Query query = _faqCollection;

    if (category != null) {
      query = query.where('category', isEqualTo: category.name);
    }

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => FAQItemMapper.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
        .toList();
  }

  // ============================================
  // FEATURE FLAGS
  // ============================================

  Future<List<FeatureFlag>> getFeatureFlags() async {
    final snapshot = await _featureFlagsCollection.get();

    return snapshot.docs
        .map((doc) => FeatureFlagMapper.fromMap({...doc.data() as Map<String, dynamic>, 'featureId': doc.id}))
        .toList();
  }

  Future<bool> isFeatureEnabled(String featureId, String userId) async {
    final doc = await _featureFlagsCollection.doc(featureId).get();

    if (!doc.exists) return false;

    final flag = FeatureFlagMapper.fromMap({...doc.data() as Map<String, dynamic>, 'featureId': doc.id});

    return flag.isEnabledForUser(userId);
  }

  // ============================================
  // ONBOARDING
  // ============================================

  Future<OnboardingProgress> getOnboardingProgress(String userId) async {
    final doc = await _onboardingCollection.doc(userId).get();

    if (!doc.exists) {
      final progress = OnboardingProgress(userId: userId, startedAt: DateTime.now());

      await _onboardingCollection.doc(userId).set(progress.toMap());
      return progress;
    }

    return OnboardingProgressMapper.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateOnboardingProgress(String userId, OnboardingStep step) async {
    await _onboardingCollection.doc(userId).update({
      'completedSteps': FieldValue.arrayUnion([step.name]),
      'currentStep': step.name,
    });
  }

  Future<void> completeOnboarding(String userId) async {
    await _onboardingCollection.doc(userId).update({
      'completedAt': FieldValue.serverTimestamp(),
      'progressPercentage': 100.0,
    });
  }

  // ============================================
  // CHAT
  // ============================================

  Future<ChatConversation?> getConversation(String conversationId) async {
    final doc = await _conversationsCollection.doc(conversationId).get();
    if (!doc.exists) return null;

    return ChatConversationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'conversationId': doc.id});
  }

  Future<List<ChatConversation>> getUserConversations(String userId) async {
    final snapshot = await _conversationsCollection
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ChatConversationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'conversationId': doc.id}))
        .toList();
  }

  Future<String> createConversation(ChatConversation conversation) async {
    final docRef = await _conversationsCollection.add(conversation.toMap());
    return docRef.id;
  }

  Future<List<ChatMessage>> getMessages(String conversationId, {int limit = 50}) async {
    final snapshot = await _messagesCollection
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('sentAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => ChatMessageMapper.fromMap({...doc.data() as Map<String, dynamic>, 'messageId': doc.id}))
        .toList();
  }

  Future<String> sendMessage(ChatMessage message) async {
    final docRef = await _messagesCollection.add(message.toMap());

    // Atualizar conversa
    await _conversationsCollection.doc(message.conversationId).update({
      'lastMessage': message.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Future<void> markMessageAsRead(String messageId) async {
    await _messagesCollection.doc(messageId).update({'isRead': true, 'readAt': FieldValue.serverTimestamp()});
  }

  // ============================================
  // ADMIN
  // ============================================

  Future<String> recordAdminAction(AdminAction action) async {
    final docRef = await _adminActionsCollection.add(action.toMap());
    return docRef.id;
  }

  Future<List<AdminAction>> getAdminActions({String? targetUserId, AdminActionType? type}) async {
    Query query = _adminActionsCollection.orderBy('performedAt', descending: true);

    if (targetUserId != null) {
      query = query.where('targetUserId', isEqualTo: targetUserId);
    }

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    final snapshot = await query.limit(100).get();

    return snapshot.docs
        .map((doc) => AdminActionMapper.fromMap({...doc.data() as Map<String, dynamic>, 'actionId': doc.id}))
        .toList();
  }

  // ============================================
  // STREAMS
  // ============================================

  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AppNotificationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'notificationId': doc.id}),
              )
              .toList(),
        );
  }

  Stream<List<ChatConversation>> watchConversations(String userId) {
    return _conversationsCollection
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ChatConversationMapper.fromMap({...doc.data() as Map<String, dynamic>, 'conversationId': doc.id}),
              )
              .toList(),
        );
  }

  Stream<List<ChatMessage>> watchMessages(String conversationId) {
    return _messagesCollection
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('sentAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessageMapper.fromMap({...doc.data() as Map<String, dynamic>, 'messageId': doc.id}))
              .toList(),
        );
  }
}
