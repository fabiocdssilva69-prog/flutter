/// Constantes globais do app
library;

class AppConstants {
  // ============================================
  // APP INFO
  // ============================================
  static const String appName = 'BarberGo';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ============================================
  // API & ENDPOINTS
  // ============================================
  static const String apiBaseUrl = 'https://api.barbergo.com';
  static const String apiVersion = 'v1';

  // ============================================
  // STORAGE KEYS
  // ============================================
  static const String keyUserId = 'user_id';
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserProfile = 'user_profile';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyBiometricEnabled = 'biometric_enabled';

  // ============================================
  // LIMITS & CONSTRAINTS
  // ============================================

  // Profile
  static const int maxPhotos = 9;
  static const int maxInterests = 20;
  static const int maxPrompts = 5;
  static const int maxBioLength = 500;
  static const int maxNameLength = 50;

  // Discovery
  static const int minAge = 18;
  static const int maxAge = 99;
  static const int defaultMinAge = 21;
  static const int defaultMaxAge = 35;
  static const int defaultMaxDistance = 50; // km
  static const int maxDistanceKm = 500;

  // Matching
  static const int dailyLikesLimit = 20; // Free tier
  static const int dailySuperLikesLimit = 1; // Free tier
  static const int dailyRewindsLimit = 0; // Free tier

  // Messaging
  static const int maxMessageLength = 1000;
  static const int maxConversations = 100;
  static const int messagesPageSize = 50;

  // Media
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 100;
  static const int maxVideoLengthSeconds = 60;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'heic'];
  static const List<String> allowedVideoFormats = ['mp4', 'mov'];

  // ============================================
  // TIMEOUTS
  // ============================================
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(minutes: 5);
  static const Duration cacheTimeout = Duration(hours: 1);
  static const Duration sessionTimeout = Duration(hours: 24);

  // ============================================
  // INTERVALS
  // ============================================
  static const Duration locationUpdateInterval = Duration(minutes: 5);
  static const Duration onlineStatusInterval = Duration(minutes: 1);
  static const Duration analyticsFlushInterval = Duration(minutes: 5);

  // ============================================
  // PAGINATION
  // ============================================
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int preloadThreshold = 5; // Load more when 5 items from end

  // ============================================
  // MONETIZATION
  // ============================================

  // Prices (BRL)
  static const double priceBasicMonthly = 19.99;
  static const double pricePremiumMonthly = 39.99;
  static const double priceEliteMonthly = 59.99;

  // Boost
  static const double priceBoostStandard = 14.99;
  static const double priceBoostSuper = 24.99;
  static const double priceBoostMega = 49.99;

  // Virtual currency
  static const int coinsPerDollar = 100;
  static const int coinsBundleSmall = 100;
  static const int coinsBundleMedium = 500;
  static const int coinsBundleLarge = 1000;

  // ============================================
  // VALIDATION
  // ============================================

  // Password
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$';

  // Email
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Phone
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';

  // ============================================
  // SOCIAL LINKS
  // ============================================
  static const String websiteUrl = 'https://barbergo.com';
  static const String privacyPolicyUrl = 'https://barbergo.com/privacy';
  static const String termsOfServiceUrl = 'https://barbergo.com/terms';
  static const String supportEmail = 'support@barbergo.com';
  static const String instagramUrl = 'https://instagram.com/barbergo';
  static const String twitterUrl = 'https://twitter.com/barbergo';

  // ============================================
  // FEATURE FLAGS (Default values)
  // ============================================
  static const bool enableAICoach = true;
  static const bool enableVideoCalls = true;
  static const bool enableVoiceCalls = true;
  static const bool enableBiometricAnalysis = true;
  static const bool enableDateIdeas = true;
  static const bool enableStoreLocator = true;
  static const bool enableVirtualGifts = true;
  static const bool enableBoosts = true;
  static const bool enableSuperLikes = true;
  static const bool enableRewinds = true;

  // ============================================
  // AI CONFIGURATION
  // ============================================
  static const String aiModelVersion = 'gpt-4';
  static const int aiMaxTokens = 500;
  static const double aiTemperature = 0.7;

  // ============================================
  // MAP CONFIGURATION
  // ============================================
  static const double defaultMapZoom = 15.0;
  static const double minMapZoom = 10.0;
  static const double maxMapZoom = 20.0;
  static const int mapRadiusMeters = 5000;

  // ============================================
  // SAFETY
  // ============================================
  static const int reportReasonMaxLength = 500;
  static const int blockListMaxSize = 500;
  static const int safetyCheckInMinutes = 60;

  // ============================================
  // ASSETS PATHS
  // ============================================
  static const String assetsImages = 'assets/images';
  static const String assetsIcons = 'assets/icons';
  static const String assetsAnimations = 'assets/animations';
  static const String assetsAudio = 'assets/audio';

  // ============================================
  // ERROR MESSAGES
  // ============================================
  static const String errorGeneric = 'Algo deu errado. Tente novamente.';
  static const String errorNetwork = 'Sem conexão com a internet.';
  static const String errorTimeout = 'A requisição demorou muito. Tente novamente.';
  static const String errorUnauthorized = 'Sessão expirada. Faça login novamente.';
  static const String errorNotFound = 'Recurso não encontrado.';
  static const String errorServerError = 'Erro no servidor. Tente novamente mais tarde.';

  // ============================================
  // SUCCESS MESSAGES
  // ============================================
  static const String successProfileUpdated = 'Perfil atualizado com sucesso!';
  static const String successPhotoUploaded = 'Foto enviada com sucesso!';
  static const String successMatchCreated = 'É um match! 🎉';
  static const String successMessageSent = 'Mensagem enviada!';
  static const String successReportSubmitted = 'Denúncia enviada. Obrigado!';
}
