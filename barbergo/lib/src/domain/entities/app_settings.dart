import 'package:dart_mappable/dart_mappable.dart';

part 'app_settings.g.dart';

/// Entity para Settings & Preferences completo
@MappableClass()
class AppSettings with AppSettingsMappable {
  final String userId;

  // Notificações
  final NotificationSettings notifications;

  // Privacidade
  final PrivacySettings privacy;

  // Descoberta
  final DiscoverySettings discovery;

  // Comunicação
  final CommunicationSettings communication;

  // Aparência
  final AppearanceSettings appearance;

  // Acessibilidade
  final AccessibilitySettings accessibility;

  // Segurança
  final SecuritySettings security;

  final DateTime updatedAt;

  const AppSettings({
    required this.userId,
    required this.notifications,
    required this.privacy,
    required this.discovery,
    required this.communication,
    required this.appearance,
    required this.accessibility,
    required this.security,
    required this.updatedAt,
  });
}

/// Configurações de notificações
@MappableClass()
class NotificationSettings with NotificationSettingsMappable {
  final bool enabled;
  final bool newMatches;
  final bool newMessages;
  final bool likes;
  final bool superLikes;
  final bool profileVisits;
  final bool reminders;
  final bool promotions;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final QuietHours? quietHours;

  const NotificationSettings({
    this.enabled = true,
    this.newMatches = true,
    this.newMessages = true,
    this.likes = true,
    this.superLikes = true,
    this.profileVisits = false,
    this.reminders = true,
    this.promotions = false,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.quietHours,
  });
}

/// Horário de silêncio
@MappableClass()
class QuietHours with QuietHoursMappable {
  final bool enabled;
  final String startTime; // "22:00"
  final String endTime; // "08:00"

  const QuietHours({this.enabled = false, this.startTime = '22:00', this.endTime = '08:00'});
}

/// Configurações de privacidade
@MappableClass()
class PrivacySettings with PrivacySettingsMappable {
  final bool showOnlineStatus;
  final bool showLastSeen;
  final bool showReadReceipts;
  final bool showTypingIndicator;
  final bool showProfileInSearch;
  final bool allowLocationSharing;
  final ProfileVisibility profileVisibility;
  final List<String> blockedUsers;
  final bool allowDataSharing;
  final bool allowAnalytics;

  const PrivacySettings({
    this.showOnlineStatus = true,
    this.showLastSeen = true,
    this.showReadReceipts = true,
    this.showTypingIndicator = true,
    this.showProfileInSearch = true,
    this.allowLocationSharing = true,
    this.profileVisibility = ProfileVisibility.everyone,
    this.blockedUsers = const [],
    this.allowDataSharing = false,
    this.allowAnalytics = true,
  });
}

enum ProfileVisibility { everyone, matches, nobody }

/// Configurações de descoberta
@MappableClass()
class DiscoverySettings with DiscoverySettingsMappable {
  final int maxDistance; // km
  final int minAge;
  final int maxAge;
  final List<String> interestedIn; // genders
  final bool showMe;
  final bool globalMode;
  final String? location;
  final List<String> dealBreakers;

  const DiscoverySettings({
    this.maxDistance = 50,
    this.minAge = 18,
    this.maxAge = 99,
    this.interestedIn = const [],
    this.showMe = true,
    this.globalMode = false,
    this.location,
    this.dealBreakers = const [],
  });
}

/// Configurações de comunicação
@MappableClass()
class CommunicationSettings with CommunicationSettingsMappable {
  final bool autoReplyEnabled;
  final String? autoReplyMessage;
  final bool allowVoiceCalls;
  final bool allowVideoCalls;
  final bool allowVoiceMessages;
  final bool filterExplicitContent;
  final MessagePreference messagePreference;

  const CommunicationSettings({
    this.autoReplyEnabled = false,
    this.autoReplyMessage,
    this.allowVoiceCalls = true,
    this.allowVideoCalls = true,
    this.allowVoiceMessages = true,
    this.filterExplicitContent = true,
    this.messagePreference = MessagePreference.everyone,
  });
}

enum MessagePreference { everyone, matchesOnly, premiumOnly }

/// Configurações de aparência
@MappableClass()
class AppearanceSettings with AppearanceSettingsMappable {
  final ThemeMode themeMode;
  final String language;
  final bool compactMode;
  final double fontSize;
  final bool showAnimations;
  final ColorScheme colorScheme;

  const AppearanceSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'pt-BR',
    this.compactMode = false,
    this.fontSize = 1.0,
    this.showAnimations = true,
    this.colorScheme = ColorScheme.default_,
  });
}

enum ThemeMode { light, dark, system }

enum ColorScheme { default_, blue, pink, purple, green }

/// Configurações de acessibilidade
@MappableClass()
class AccessibilitySettings with AccessibilitySettingsMappable {
  final bool screenReader;
  final bool highContrast;
  final bool reducedMotion;
  final bool largeText;
  final bool hapticFeedback;
  final bool voiceGuidance;

  const AccessibilitySettings({
    this.screenReader = false,
    this.highContrast = false,
    this.reducedMotion = false,
    this.largeText = false,
    this.hapticFeedback = true,
    this.voiceGuidance = false,
  });
}

/// Configurações de segurança
@MappableClass()
class SecuritySettings with SecuritySettingsMappable {
  final bool biometricEnabled;
  final bool requirePinOnOpen;
  final String? pin;
  final bool twoFactorEnabled;
  final bool loginAlerts;
  final List<LoginSession> activeSessions;

  const SecuritySettings({
    this.biometricEnabled = false,
    this.requirePinOnOpen = false,
    this.pin,
    this.twoFactorEnabled = false,
    this.loginAlerts = true,
    this.activeSessions = const [],
  });
}

/// Sessão de login
@MappableClass()
class LoginSession with LoginSessionMappable {
  final String sessionId;
  final String deviceName;
  final String deviceType;
  final String location;
  final DateTime loginTime;
  final DateTime lastActive;
  final bool isCurrent;

  const LoginSession({
    required this.sessionId,
    required this.deviceName,
    required this.deviceType,
    required this.location,
    required this.loginTime,
    required this.lastActive,
    this.isCurrent = false,
  });
}

/// Sistema de suporte
@MappableClass()
class SupportTicket with SupportTicketMappable {
  final String ticketId;
  final String userId;
  final TicketCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final String subject;
  final String description;
  final List<SupportMessage> messages;
  final List<String> attachments;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;

  const SupportTicket({
    required this.ticketId,
    required this.userId,
    required this.category,
    this.priority = TicketPriority.normal,
    required this.status,
    required this.subject,
    required this.description,
    this.messages = const [],
    this.attachments = const [],
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
  });
}

enum TicketCategory { account, billing, technical, safety, features, feedback, other }

enum TicketPriority { low, normal, high, urgent }

enum TicketStatus { open, inProgress, waitingForResponse, resolved, closed }

/// Mensagem do ticket
@MappableClass()
class SupportMessage with SupportMessageMappable {
  final String messageId;
  final String authorId;
  final String authorName;
  final bool isStaff;
  final String content;
  final DateTime createdAt;

  const SupportMessage({
    required this.messageId,
    required this.authorId,
    required this.authorName,
    this.isStaff = false,
    required this.content,
    required this.createdAt,
  });
}

/// FAQ
@MappableClass()
class FAQItem with FAQItemMappable {
  final String id;
  final FAQCategory category;
  final String question;
  final String answer;
  final int viewCount;
  final bool isHelpful;
  final List<String> relatedQuestions;

  const FAQItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    this.viewCount = 0,
    this.isHelpful = false,
    this.relatedQuestions = const [],
  });
}

enum FAQCategory { gettingStarted, account, matches, messaging, safety, subscription, technical }

/// Menu item
@MappableClass()
class MenuItem with MenuItemMappable {
  final String id;
  final String title;
  final String? subtitle;
  final String? icon;
  final String route;
  final bool requiresAuth;
  final bool requiresPremium;
  final List<MenuItem> subItems;
  final int? badgeCount;

  const MenuItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    required this.route,
    this.requiresAuth = false,
    this.requiresPremium = false,
    this.subItems = const [],
    this.badgeCount,
  });
}

/// Feature flag
@MappableClass()
class FeatureFlag with FeatureFlagMappable {
  final String featureId;
  final String name;
  final bool enabled;
  final List<String> enabledForUsers;
  final double rolloutPercentage;
  final DateTime? startDate;
  final DateTime? endDate;

  const FeatureFlag({
    required this.featureId,
    required this.name,
    this.enabled = false,
    this.enabledForUsers = const [],
    this.rolloutPercentage = 0,
    this.startDate,
    this.endDate,
  });

  bool isEnabledForUser(String userId) {
    if (!enabled) return false;
    if (enabledForUsers.contains(userId)) return true;
    // Implementar lógica de rollout percentage
    return false;
  }
}
