import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Sistema completo de rotas e navegação

class AppRoutes {
  // ============================================
  // ROOT ROUTES
  // ============================================
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';

  // ============================================
  // MAIN APP ROUTES
  // ============================================
  static const home = '/home';
  static const discovery = '/discovery';
  static const matches = '/matches';
  static const messages = '/messages';
  static const profile = '/profile';

  // ============================================
  // PROFILE ROUTES
  // ============================================
  static const editProfile = '/profile/edit';
  static const myPhotos = '/profile/photos';
  static const myInterests = '/profile/interests';
  static const myPreferences = '/profile/preferences';
  static const myPrompts = '/profile/prompts';

  // ============================================
  // USER PROFILE
  // ============================================
  static const userProfile = '/user/:userId';

  // ============================================
  // CHAT ROUTES
  // ============================================
  static const chat = '/chat/:conversationId';
  static const videocall = '/videocall/:conversationId';
  static const voicecall = '/voicecall/:conversationId';

  // ============================================
  // DISCOVERY & MATCHING
  // ============================================
  static const swipe = '/swipe';
  static const topPicks = '/top-picks';
  static const whoLikesYou = '/likes';
  static const superLikes = '/super-likes';

  // ============================================
  // DATING FEATURES
  // ============================================
  static const dateIdeas = '/date-ideas';
  static const dateIdea = '/date-ideas/:ideaId';
  static const compatibilityQuiz = '/compatibility-quiz';
  static const quizResults = '/quiz-results';

  // ============================================
  // O2O & MAPS
  // ============================================
  static const nearbyPlaces = '/nearby';
  static const placeDetails = '/place/:placeId';
  static const mapExplorer = '/map';

  // ============================================
  // MONETIZATION
  // ============================================
  static const subscription = '/subscription';
  static const subscriptionPlans = '/subscription/plans';
  static const store = '/store';
  static const boosts = '/boosts';
  static const gifts = '/gifts';
  static const analytics = '/analytics';

  // ============================================
  // AI FEATURES
  // ============================================
  static const aiCoach = '/ai-coach';
  static const aiChat = '/ai-chat';
  static const biometricAnalysis = '/bio-analysis';

  // ============================================
  // SAFETY & VERIFICATION
  // ============================================
  static const verification = '/verification';
  static const safetyCenter = '/safety';
  static const reportUser = '/report/:userId';
  static const blockList = '/blocked-users';

  // ============================================
  // SETTINGS
  // ============================================
  static const settings = '/settings';
  static const notificationSettings = '/settings/notifications';
  static const privacySettings = '/settings/privacy';
  static const securitySettings = '/settings/security';
  static const accountSettings = '/settings/account';
  static const appearanceSettings = '/settings/appearance';
  static const accessibilitySettings = '/settings/accessibility';

  // ============================================
  // NEW PREMIUM FEATURES (Sprint Nov 2025)
  // ============================================
  static const chatList = '/chat-list';
  static const chatRoom = '/chat-room/:roomId';
  static const payment = '/payment';
  static const paymentBooking = '/payment/:bookingId';
  static const biDashboard = '/bi-dashboard';

  // ============================================
  // SUPPORT
  // ============================================
  static const help = '/help';
  static const faq = '/faq';
  static const support = '/support';
  static const contactUs = '/contact';

  // ============================================
  // ADMIN (privileged)
  // ============================================
  static const admin = '/admin';
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static const adminReports = '/admin/reports';
}

/// Navigation Service Helper
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static Future<T?>? push<T extends Object?>(String route, {Object? extra}) {
    return context?.push(route, extra: extra);
  }

  static Future<T?>? pushNamed<T extends Object?>(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    return context?.pushNamed(
      name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
      extra: extra,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    return context?.pop(result);
  }

  static void go(String route, {Object? extra}) {
    return context?.go(route, extra: extra);
  }

  static void goNamed(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    return context?.goNamed(
      name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
      extra: extra,
    );
  }

  static Future<T?>? pushReplacement<T extends Object?>(String route, {Object? extra}) {
    context?.pushReplacement(route, extra: extra);
    return null;
  }

  static bool canPop() {
    return context?.canPop() ?? false;
  }

  static void popUntil(String route) {
    while (context?.canPop() ?? false) {
      if (GoRouterState.of(context!).uri.toString() == route) break;
      context?.pop();
    }
  }
}

/// Bottom Navigation Helper
class BottomNavItem {
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const BottomNavItem({required this.route, required this.icon, required this.selectedIcon, required this.label});
}

/// Main Bottom Navigation Items
final List<BottomNavItem> mainBottomNavItems = [
  BottomNavItem(
    route: AppRoutes.discovery,
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore,
    label: 'Descobrir',
  ),
  BottomNavItem(route: AppRoutes.matches, icon: Icons.favorite_border, selectedIcon: Icons.favorite, label: 'Matches'),
  BottomNavItem(
    route: AppRoutes.messages,
    icon: Icons.chat_bubble_outline,
    selectedIcon: Icons.chat_bubble,
    label: 'Mensagens',
  ),
  BottomNavItem(route: AppRoutes.profile, icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Perfil'),
];

/// Deep Link Handler
class DeepLinkHandler {
  static Future<void> handleDeepLink(String link) async {
    // Parse link and navigate
    final uri = Uri.parse(link);

    switch (uri.path) {
      case '/match':
        final userId = uri.queryParameters['userId'];
        if (userId != null) {
          NavigationService.push('/user/$userId');
        }
        break;

      case '/message':
        final conversationId = uri.queryParameters['conversationId'];
        if (conversationId != null) {
          NavigationService.push('/chat/$conversationId');
        }
        break;

      case '/date-idea':
        final ideaId = uri.queryParameters['ideaId'];
        if (ideaId != null) {
          NavigationService.push('/date-ideas/$ideaId');
        }
        break;

      default:
        NavigationService.go(AppRoutes.home);
    }
  }
}

/// Route Guards
class RouteGuard {
  static bool requiresAuth(String route) {
    const publicRoutes = [AppRoutes.splash, AppRoutes.onboarding, AppRoutes.login, AppRoutes.register];

    return !publicRoutes.contains(route);
  }

  static bool requiresPremium(String route) {
    const premiumRoutes = [AppRoutes.whoLikesYou, AppRoutes.analytics, AppRoutes.topPicks];

    return premiumRoutes.contains(route);
  }

  static bool requiresAdmin(String route) {
    return route.startsWith('/admin');
  }
}

/// Navigation Analytics Wrapper
class AnalyticsNavigationObserver extends NavigatorObserver {
  final void Function(String routeName) onRouteChange;

  AnalyticsNavigationObserver({required this.onRouteChange});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      onRouteChange(route.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name != null) {
      onRouteChange(previousRoute!.settings.name!);
    }
  }
}
