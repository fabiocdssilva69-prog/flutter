import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/user_repository.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/screens/account_type_selection_screen.dart';
import '../features/profiles/presentation/create_profile_screen.dart';
import '../features/vacancies/presentation/create_vacancy_screen.dart';
import '../features/vacancies/presentation/vacancy_detail_screen.dart';
import '../features/management/screens/vacancy_details_screen.dart';
import '../core/widgets/loading_screen.dart';
import '../core/screens/ai_test_screen.dart';
import '../features/ai/screens/artistic_chat_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // 1. Observar o estado de autenticação (Firebase Auth)
  final authState = ref.watch(authStateChangesProvider);

  // 2. Observar o estado do cadastro/onboarding (Firestore UserEntity)
  // Usamos currentUserDataProvider que criamos no UserRepository.
  final userDataState = ref.watch(currentUserDataProvider);

  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    // 3. Lógica de Redirecionamento Refinada
    redirect: (BuildContext context, GoRouterState state) {
      // --- ESTADO DE CARREGAMENTO ---
      // Se Auth OU UserData estiverem carregando, mostre Loading.
      final isLoading =
          authState.isLoading ||
          authState.hasError ||
          userDataState.isLoading ||
          userDataState.hasError;
      if (isLoading) {
        return state.matchedLocation == '/loading' ? null : '/loading';
      }

      // --- ESTADO DE AUTENTICAÇÃO ---
      final bool loggedIn = authState.value != null;
      final bool onAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      // Se não estiver logado, redirecione para login (a menos que já esteja lá ou no signup).
      if (!loggedIn) {
        return onAuthPage ? null : '/login';
      }

      // --- ESTADO DE ONBOARDING ---
      // Se o UserEntity não existir no Firestore (value é null), o onboarding está incompleto.
      final bool onboardingComplete = userDataState.value != null;
      final bool onOnboardingPage = state.matchedLocation.startsWith(
        '/onboarding',
      );

      // Se estiver logado, MAS o onboarding estiver incompleto, force para a tela de seleção de conta.
      if (!onboardingComplete) {
        return onOnboardingPage ? null : '/onboarding/select-account';
      }

      // --- ESTADO COMPLETO (Logado e Onboarded) ---
      // Se estiver completo, mas ainda nas páginas de auth/onboarding/loading, redirecione para a Home.
      if (onAuthPage ||
          onOnboardingPage ||
          state.matchedLocation == '/loading') {
        return '/home';
      }

      // Caso contrário, prossiga para a rota desejada.
      return null;
    },
    // 4. Definição das Rotas (Garantir que todas as rotas estejam aqui)
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/onboarding/select-account',
        builder: (context, state) => const AccountTypeSelectionScreen(),
      ),
      GoRoute(
        path: '/profiles/create',
        builder: (context, state) => const CreateProfileScreen(),
      ),
      GoRoute(
        path: '/create-profile',
        builder: (context, state) => const CreateProfileScreen(),
      ),
      GoRoute(
        path: '/vacancies/create',
        builder: (context, state) => const CreateVacancyScreen(),
      ),
      GoRoute(
        path: '/vacancies/:vacancyId',
        builder: (context, state) => VacancyDetailScreen.fromRoute(state),
      ),
      GoRoute(
        path: '/create-vacancy',
        builder: (context, state) => const CreateVacancyScreen(),
      ),
      GoRoute(
        path: '/vacancy-details/:vid',
        builder: (context, state) => VacancyDetailsScreen.fromRoute(state),
      ),
      GoRoute(
        path: '/ai-test',
        builder: (context, state) => const AITestScreen(),
      ),
      GoRoute(
        path: '/ai/chat/artistic',
        builder: (context, state) => const ArtisticChatScreen(),
      ),
    ],
  );
}
