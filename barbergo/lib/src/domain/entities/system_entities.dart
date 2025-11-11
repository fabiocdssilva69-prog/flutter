import 'package:dart_mappable/dart_mappable.dart';

part 'notification.g.dart';

/// Sistema completo de notificações
@MappableClass()
class AppNotification with AppNotificationMappable {
  final String notificationId;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;
  final String? actionUrl;
  final NotificationPriority priority;

  const AppNotification({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data = const {},
    this.isRead = false,
    required this.createdAt,
    this.readAt,
    this.actionUrl,
    this.priority = NotificationPriority.normal,
  });
}

enum NotificationType {
  newMatch,
  newMessage,
  newLike,
  superLike,
  profileVisit,
  iceBreaker,
  reminder,
  boost,
  gift,
  safety,
  system,
  promotion,
}

enum NotificationPriority { low, normal, high, urgent }

/// Navegação
@MappableClass()
class AppRoute with AppRouteMappable {
  final String path;
  final String name;
  final bool requiresAuth;
  final bool requiresPremium;
  final Map<String, dynamic> arguments;

  const AppRoute({
    required this.path,
    required this.name,
    this.requiresAuth = false,
    this.requiresPremium = false,
    this.arguments = const {},
  });
}

/// Onboarding
@MappableClass()
class OnboardingProgress with OnboardingProgressMappable {
  final String userId;
  final List<OnboardingStep> completedSteps;
  final OnboardingStep? currentStep;
  final double progressPercentage;
  final DateTime startedAt;
  final DateTime? completedAt;

  const OnboardingProgress({
    required this.userId,
    this.completedSteps = const [],
    this.currentStep,
    this.progressPercentage = 0,
    required this.startedAt,
    this.completedAt,
  });
}

enum OnboardingStep {
  welcome,
  createProfile,
  uploadPhotos,
  setPreferences,
  enableNotifications,
  tutorial,
  firstSwipe,
  complete,
}

/// Chat
@MappableClass()
class ChatConversation with ChatConversationMappable {
  final String conversationId;
  final List<String> participants;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatConversation({
    required this.conversationId,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });
}

@MappableClass()
class ChatMessage with ChatMessageMappable {
  final String messageId;
  final String conversationId;
  final String senderId;
  final MessageType type;
  final String content;
  final List<String> attachments;
  final bool isRead;
  final DateTime sentAt;
  final DateTime? readAt;
  final DateTime? deletedAt;
  final String? replyToId;

  const ChatMessage({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    this.type = MessageType.text,
    required this.content,
    this.attachments = const [],
    this.isRead = false,
    required this.sentAt,
    this.readAt,
    this.deletedAt,
    this.replyToId,
  });
}

enum MessageType { text, image, video, audio, location, gif, sticker, file }

/// Search & Filters
@MappableClass()
class SearchFilters with SearchFiltersMappable {
  final int? minAge;
  final int? maxAge;
  final int? maxDistance;
  final List<String> interests;
  final List<String> educationLevels;
  final List<String> occupations;
  final List<String> relationshipGoals;
  final bool verifiedOnly;
  final bool hasPhotos;
  final bool activeRecently;

  const SearchFilters({
    this.minAge,
    this.maxAge,
    this.maxDistance,
    this.interests = const [],
    this.educationLevels = const [],
    this.occupations = const [],
    this.relationshipGoals = const [],
    this.verifiedOnly = false,
    this.hasPhotos = false,
    this.activeRecently = false,
  });
}

/// Admin
@MappableClass()
class AdminAction with AdminActionMappable {
  final String actionId;
  final String adminId;
  final AdminActionType type;
  final String targetUserId;
  final String reason;
  final Map<String, dynamic> metadata;
  final DateTime performedAt;

  const AdminAction({
    required this.actionId,
    required this.adminId,
    required this.type,
    required this.targetUserId,
    required this.reason,
    this.metadata = const {},
    required this.performedAt,
  });
}

enum AdminActionType { warn, suspend, ban, verify, unverify, resetPassword, deleteContent, featureUser, grantPremium }
