import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/system_repository.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/system_entities.dart';

part 'system_controller.g.dart';

@riverpod
class SystemController extends _$SystemController {
  @override
  FutureOr<bool> build() {
    return true; // Initialization
  }

  SystemRepository get _repository => ref.read(systemRepositoryProvider);

  // ============================================
  // SETTINGS
  // ============================================

  Future<AppSettings> getSettings(String userId) async {
    return await _repository.getUserSettings(userId);
  }

  Future<void> updateNotificationSettings(String userId, NotificationSettings settings) async {
    await _repository.updateSettings(userId, {'notifications': settings.toMap()});
    ref.invalidate(userSettingsProvider(userId));
  }

  Future<void> updatePrivacySettings(String userId, PrivacySettings settings) async {
    await _repository.updateSettings(userId, {'privacy': settings.toMap()});
    ref.invalidate(userSettingsProvider(userId));
  }

  Future<void> updateDiscoverySettings(String userId, DiscoverySettings settings) async {
    await _repository.updateSettings(userId, {'discovery': settings.toMap()});
    ref.invalidate(userSettingsProvider(userId));
  }

  Future<void> updateAppearanceSettings(String userId, AppearanceSettings settings) async {
    await _repository.updateSettings(userId, {'appearance': settings.toMap()});
    ref.invalidate(userSettingsProvider(userId));
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    final settings = await getSettings(userId);
    final updatedBlockedUsers = [...settings.privacy.blockedUsers, blockedUserId];

    await updatePrivacySettings(userId, settings.privacy.copyWith(blockedUsers: updatedBlockedUsers));
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    final settings = await getSettings(userId);
    final updatedBlockedUsers = settings.privacy.blockedUsers.where((id) => id != blockedUserId).toList();

    await updatePrivacySettings(userId, settings.privacy.copyWith(blockedUsers: updatedBlockedUsers));
  }

  // ============================================
  // NOTIFICATIONS
  // ============================================

  Future<List<AppNotification>> getNotifications(String userId) async {
    return await _repository.getUserNotifications(userId);
  }

  Future<int> getUnreadCount(String userId) async {
    return await _repository.getUnreadNotificationCount(userId);
  }

  Future<void> markAsRead(String notificationId) async {
    await _repository.markNotificationAsRead(notificationId);
  }

  Future<void> markAllAsRead(String userId) async {
    await _repository.markAllNotificationsAsRead(userId);
  }

  Future<void> sendNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? actionUrl,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    final notification = AppNotification(
      notificationId: '',
      userId: userId,
      type: type,
      title: title,
      body: body,
      data: data ?? {},
      createdAt: DateTime.now(),
      actionUrl: actionUrl,
      priority: priority,
    );

    await _repository.createNotification(notification);
  }

  // ============================================
  // SUPPORT
  // ============================================

  Future<String> createTicket({
    required String userId,
    required TicketCategory category,
    required String subject,
    required String description,
    List<String>? attachments,
    TicketPriority priority = TicketPriority.normal,
  }) async {
    final ticket = SupportTicket(
      ticketId: '',
      userId: userId,
      category: category,
      priority: priority,
      status: TicketStatus.open,
      subject: subject,
      description: description,
      attachments: attachments ?? [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await _repository.createSupportTicket(ticket);
  }

  Future<List<SupportTicket>> getUserTickets(String userId) async {
    return await _repository.getUserTickets(userId);
  }

  Future<void> replyToTicket(String ticketId, String userId, String message) async {
    final supportMessage = SupportMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: userId,
      authorName: 'User',
      content: message,
      createdAt: DateTime.now(),
    );

    await _repository.addMessageToTicket(ticketId, supportMessage);
  }

  // ============================================
  // FAQ
  // ============================================

  Future<List<FAQItem>> getFAQs({FAQCategory? category}) async {
    return await _repository.getFAQs(category: category);
  }

  // ============================================
  // FEATURE FLAGS
  // ============================================

  Future<bool> isFeatureEnabled(String featureId, String userId) async {
    return await _repository.isFeatureEnabled(featureId, userId);
  }

  // ============================================
  // ONBOARDING
  // ============================================

  Future<OnboardingProgress> getOnboardingProgress(String userId) async {
    return await _repository.getOnboardingProgress(userId);
  }

  Future<void> completeOnboardingStep(String userId, OnboardingStep step) async {
    await _repository.updateOnboardingProgress(userId, step);
    ref.invalidate(onboardingProgressProvider(userId));
  }

  Future<void> finishOnboarding(String userId) async {
    await _repository.completeOnboarding(userId);
    ref.invalidate(onboardingProgressProvider(userId));
  }

  // ============================================
  // CHAT
  // ============================================

  Future<List<ChatConversation>> getConversations(String userId) async {
    return await _repository.getUserConversations(userId);
  }

  Future<ChatConversation?> getConversation(String conversationId) async {
    return await _repository.getConversation(conversationId);
  }

  Future<String> startConversation(List<String> participants) async {
    final conversation = ChatConversation(
      conversationId: '',
      participants: participants,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await _repository.createConversation(conversation);
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    return await _repository.getMessages(conversationId);
  }

  Future<String> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    List<String>? attachments,
    String? replyToId,
  }) async {
    final message = ChatMessage(
      messageId: '',
      conversationId: conversationId,
      senderId: senderId,
      type: type,
      content: content,
      attachments: attachments ?? [],
      sentAt: DateTime.now(),
      replyToId: replyToId,
    );

    return await _repository.sendMessage(message);
  }

  // ============================================
  // ADMIN
  // ============================================

  Future<void> performAdminAction({
    required String adminId,
    required AdminActionType type,
    required String targetUserId,
    required String reason,
    Map<String, dynamic>? metadata,
  }) async {
    final action = AdminAction(
      actionId: '',
      adminId: adminId,
      type: type,
      targetUserId: targetUserId,
      reason: reason,
      metadata: metadata ?? {},
      performedAt: DateTime.now(),
    );

    await _repository.recordAdminAction(action);
  }

  Future<List<AdminAction>> getAdminActions({String? targetUserId, AdminActionType? type}) async {
    return await _repository.getAdminActions(targetUserId: targetUserId, type: type);
  }
}

// ============================================
// PROVIDERS
// ============================================

@riverpod
Future<AppSettings> userSettings(UserSettingsRef ref, String userId) async {
  final controller = ref.read(systemControllerProvider.notifier);
  return await controller.getSettings(userId);
}

@riverpod
Stream<List<AppNotification>> notificationsStream(NotificationsStreamRef ref, String userId) {
  final repository = ref.read(systemRepositoryProvider);
  return repository.watchNotifications(userId);
}

@riverpod
Future<int> unreadNotificationCount(UnreadNotificationCountRef ref, String userId) async {
  final controller = ref.read(systemControllerProvider.notifier);
  return await controller.getUnreadCount(userId);
}

@riverpod
Future<OnboardingProgress> onboardingProgress(OnboardingProgressRef ref, String userId) async {
  final controller = ref.read(systemControllerProvider.notifier);
  return await controller.getOnboardingProgress(userId);
}

@riverpod
Stream<List<ChatConversation>> conversationsStream(ConversationsStreamRef ref, String userId) {
  final repository = ref.read(systemRepositoryProvider);
  return repository.watchConversations(userId);
}

@riverpod
Stream<List<ChatMessage>> messagesStream(MessagesStreamRef ref, String conversationId) {
  final repository = ref.read(systemRepositoryProvider);
  return repository.watchMessages(conversationId);
}

@riverpod
Future<List<FAQItem>> faqList(FaqListRef ref, {FAQCategory? category}) async {
  final controller = ref.read(systemControllerProvider.notifier);
  return await controller.getFAQs(category: category);
}
