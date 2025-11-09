import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/screens/ai_test_screen.dart';
import '../core/widgets/loading_screen.dart';
import '../data/repositories/auth_repository.dart';
import '../domain/entities/chat/chat_room_entity.dart';
import '../domain/entities/enums.dart';
import '../domain/entities/profile_entity.dart';
import '../features/accessibility/screens/accessibility_settings_screen.dart';
import '../features/ai/screens/artistic_chat_screen.dart';
import '../features/ai/screens/generic_chat_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/bi_dashboard/screens/bi_dashboard_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
// NEW PREMIUM FEATURES (Sprint Nov 2025)
import '../features/chat/screens/chat_room_screen.dart';
import '../features/chat/screens/direct_message_screen.dart';
import '../features/chat/screens/match_screen.dart';
import '../features/core/initialization_error_screen.dart';
import '../features/core/splash_screen.dart';
import '../features/debug/image_test_screen.dart'; // NOVO: Tela de teste de URLs
import '../features/debug/seed_screen.dart';
import '../features/discovery/presentation/swipe_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/management/screens/vacancy_details_screen.dart';
import '../features/matches/presentation/matches_screen.dart';
import '../features/notifications/screens/notification_inbox_screen.dart';
import '../features/onboarding/providers/tutorial_provider.dart';
import '../features/onboarding/screens/account_type_selection_screen.dart';
import '../features/onboarding/screens/tutorial_screen.dart';
import '../features/payments/screens/payment_screen.dart';
import '../features/profile/controllers/profile_controller.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profiles/presentation/create_profile_screen.dart';
import '../features/vacancies/presentation/create_vacancy_screen.dart';
import '../features/vacancies/presentation/vacancy_detail_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  // Observa os estados como AsyncValue
  final authState = ref.watch(authStateChangesProvider);
  final profileState = ref.watch(currentUserProfileProvider);
  final tutorialState = ref.watch(tutorialCompletedProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    // Tratamento de erro global
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Erro na navegação', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Detalhes: ${state.error}', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => context.go('/login'), child: const Text('Ir para Login')),
            ],
          ),
        ),
      );
    },
    // Lógica de Redirecionamento Resiliente
    redirect: (context, state) {
      final currentRoute = state.matchedLocation;

      // 🔍 DEBUG: Log do estado atual
      debugPrint('🔄 REDIRECT CHECK: $currentRoute');
      debugPrint(
        '  Auth: loading=${authState.isLoading}, hasValue=${authState.hasValue}, hasError=${authState.hasError}',
      );
      debugPrint(
        '  Profile: loading=${profileState.isLoading}, hasValue=${profileState.hasValue}, hasError=${profileState.hasError}, value=${profileState.value?.name ?? "NULL"}',
      );
      debugPrint('  Tutorial: loading=${tutorialState.isLoading}, value=${tutorialState.value}');

      // 1. Tratamento de Erros de Inicialização (Prioridade Máxima)
      // Apenas erros críticos de Auth, não erros de perfil ausente
      if (authState.hasError) {
        debugPrint('  ❌ ERRO CRÍTICO de Auth detectado! Auth error: ${authState.error}');
        // Prevenção de loops: Se já estiver na tela de erro, não redireciona.
        if (currentRoute.startsWith('/initialization-error')) return null;

        // Redireciona passando a mensagem de erro como parâmetro
        debugPrint('  🚨 Redirecionando para tela de erro: ${authState.error}');
        return '/initialization-error?message=${Uri.encodeComponent(authState.error.toString())}';
      }

      // 2. Tratamento de Estado de Carregamento (Inicialização)
      // Consideramos inicializando se Auth está carregando OU (Auth OK E Profile carregando).
      // Com o timeout otimizado, isso não fica preso.
      final isInitializing = authState.isLoading || (authState.hasValue && profileState.isLoading);

      if (isInitializing) {
        debugPrint('  ⏳ Inicializando... Redirecionando para Splash');
        // Se estiver inicializando, vá para Splash.
        return currentRoute == '/splash' ? null : '/splash';
      }

      // 3. Verificação de Autenticação (PRIMEIRO - antes do tutorial)
      final isAuthenticated = authState.value != null;
      final isAuthRoute = currentRoute.startsWith('/login') || currentRoute.startsWith('/register');

      debugPrint('  🔍 isAuthenticated=$isAuthenticated, authValue=${authState.value}');

      if (!isAuthenticated) {
        debugPrint('  🔐 Não autenticado. Redirecionando para Login');
        return isAuthRoute ? null : '/login';
      }

      // 4. Verificação do Tutorial (primeira vez no app)
      // APENAS se o usuário estiver autenticado
      final tutorialCompleted = tutorialState.value ?? false;
      final isTutorialRoute = currentRoute.startsWith('/tutorial');

      if (!tutorialState.isLoading && !tutorialCompleted && !isTutorialRoute) {
        debugPrint('  📚 Tutorial não concluído. Redirecionando para Tutorial');
        return '/tutorial';
      }

      // 5. Verificação de Onboarding
      // Se chegamos aqui, Auth está OK e Profile não tem erro (pode ser null ou ter dados).
      final isOnboardingIncomplete = profileState.value == null;
      final isOnboardingRoute = currentRoute.startsWith('/onboarding');

      // ✅ FIX CRÍTICO: Verifica profile null ANTES de qualquer outra lógica de redirecionamento
      // Isso previne o loop infinito /home → /splash → /home
      if (isOnboardingIncomplete && !isOnboardingRoute) {
        debugPrint('  👤 Perfil incompleto. Redirecionando para Onboarding');
        return '/onboarding';
      }

      // 6. Autenticado e com Perfil Completo
      // Se estiver em rotas de setup/erro, redireciona para Home.
      // MAS só se o tutorial foi concluído E o perfil existe (senão fica em loop)
      if ((currentRoute == '/splash' ||
              isAuthRoute ||
              isOnboardingRoute ||
              currentRoute.startsWith('/initialization-error')) &&
          tutorialCompleted &&
          !isOnboardingIncomplete) {
        debugPrint('  ✅ Setup completo. Redirecionando para Home');
        return '/home';
      }

      // Se está em /tutorial mas tutorial não foi concluído, PERMITE ficar lá
      if (isTutorialRoute && !tutorialCompleted) {
        debugPrint('  📚 Permitindo acesso ao Tutorial');
        return null;
      }

      // Se está em splash/auth mas tutorial não foi concluído, vai para tutorial
      if ((currentRoute == '/splash' || isAuthRoute) && !tutorialCompleted) {
        debugPrint('  📚 Redirecionando para Tutorial (setup incompleto)');
        return '/tutorial';
      }

      // Permite a navegação normal
      debugPrint('  ✅ Navegação permitida para $currentRoute');
      return null;
    },
    // Definição das Rotas
    routes: [
      // Rota de Erro de Inicialização (NOVO)
      GoRoute(
        path: '/initialization-error',
        builder: (context, state) {
          // Extrai a mensagem de erro dos parâmetros da query
          final errorMessage = state.uri.queryParameters['message'] ?? 'Erro desconhecido na inicialização.';
          return InitializationErrorScreen(errorMessage: errorMessage);
        },
      ),

      // Rota Splash
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),

      // Rota Tutorial (Onboarding inicial do app)
      GoRoute(path: '/tutorial', builder: (context, state) => const TutorialScreen()),

      // Rota de Onboarding (Perfil em modo Onboarding)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) {
          // Tenta ler o 'accountType' se fornecido (útil se viermos direto do registro)
          final accountTypeQuery = state.uri.queryParameters['type'];
          AccountType? initialType;
          if (accountTypeQuery == 'barber') initialType = AccountType.barber;
          if (accountTypeQuery == 'barbershop') initialType = AccountType.barbershop;

          return ProfileScreen(isOnboarding: true, initialAccountType: initialType);
        },
      ),

      // Rotas de autenticação
      GoRoute(path: '/loading', builder: (context, state) => const LoadingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),

      // Rotas principais
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationInboxScreen()),

      // Rota de Debug (Seed Database)
      GoRoute(path: '/debug/seed', builder: (context, state) => const SeedScreen()),
      // Rota de Debug (Image URL Tester) - NOVO: Testar carregamento de URLs
      GoRoute(path: '/debug/images', builder: (context, state) => const ImageTestScreen()),

      // --- ROTAS DE SWIPE E MATCHES ---
      GoRoute(path: '/swipe', builder: (context, state) => const SwipeScreen()),
      GoRoute(path: '/matches', builder: (context, state) => const MatchesScreen()),
      // Rota de Chat (novo sistema de matches)
      GoRoute(
        path: '/chat/:chatId',
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'];
          final otherUser = state.extra as ProfileEntity?;

          if (chatId == null || otherUser == null) {
            return const Scaffold(body: Center(child: Text('Erro: Informações do chat não encontradas')));
          }

          return ChatScreen(chatId: chatId, otherUser: otherUser);
        },
      ),
      // --------------------------------

      // --- ROTA ANTIGA (Chat Direto - manter para compatibilidade) ---
      GoRoute(
        path: '/direct-message',
        builder: (context, state) {
          // Usamos 'extra' para passar objetos complexos (ChatRoomEntity)
          final room = state.extra as ChatRoomEntity?;

          if (room == null) {
            // Tratamento de erro robusto caso o objeto não seja passado
            return const Scaffold(body: Center(child: Text("Erro: Sala de chat não encontrada. Acesse pelo Inbox.")));
          }
          return DirectMessageScreen(room: room);
        },
      ),
      // --------------------------------

      // --- NOVA ROTA (Match Celebration) ---
      GoRoute(
        path: '/match',
        pageBuilder: (context, state) {
          // Espera o objeto ChatRoomEntity via 'extra'
          final room = state.extra as ChatRoomEntity?;

          if (room == null) {
            return const MaterialPage(
              child: Scaffold(body: Center(child: Text("Erro ao carregar tela de Match."))),
            );
          }

          // Abre como um modal (fullscreenDialog)
          return MaterialPage(fullscreenDialog: true, child: MatchScreen(room: room));
        },
      ),
      // --------------------------------

      // Rotas antigas de onboarding/profile (manter para compatibilidade)
      GoRoute(path: '/onboarding/select-account', builder: (context, state) => const AccountTypeSelectionScreen()),
      GoRoute(path: '/profiles/create', builder: (context, state) => const CreateProfileScreen()),
      GoRoute(path: '/create-profile', builder: (context, state) => const CreateProfileScreen()),

      // Rota de edição de perfil
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) {
          final profile = ref.read(currentUserProfileProvider).value;

          if (profile == null) {
            return const Scaffold(body: Center(child: Text('Erro: Perfil não encontrado')));
          }

          return EditProfileScreen(profile: profile);
        },
      ),

      GoRoute(path: '/vacancies/create', builder: (context, state) => const CreateVacancyScreen()),
      GoRoute(path: '/vacancies/:vacancyId', builder: (context, state) => VacancyDetailScreen.fromRoute(state)),
      GoRoute(path: '/create-vacancy', builder: (context, state) => const CreateVacancyScreen()),
      GoRoute(
        path: '/vacancy-details/:vid',
        builder: (context, state) {
          final vacancyId = state.pathParameters['vid']!;
          return VacancyDetailsScreen(vacancyId: vacancyId);
        },
      ),
      GoRoute(path: '/ai-test', builder: (context, state) => const AITestScreen()),
      GoRoute(path: '/ai/chat/artistic', builder: (context, state) => const ArtisticChatScreen()),
      GoRoute(
        path: '/ai/chat/:persona',
        builder: (context, state) {
          final personaKey = state.pathParameters['persona'];
          String title;
          String description;
          List<String> suggestions = []; // Inicializa a lista de sugestões

          switch (personaKey) {
            case 'business':
              title = "Consultor de Negócios IA";
              description =
                  "Como posso ajudar a otimizar sua barbearia hoje? Pergunte sobre marketing, finanças ou gestão.";
              suggestions = [
                "Como atrair mais clientes?",
                "Dicas para controle de estoque.",
                "Estratégias de precificação.",
              ];
              break;
            case 'artistic':
              title = "Chatbot Artístico";
              description = "Vamos explorar novas tendências e estilos juntos! Peça inspiração.";
              suggestions = [
                "Tendências de corte para 2025.",
                "Ideias para cabelo cacheado.",
                "Técnicas avançadas de fade.",
              ];
              break;
            case 'writing':
              title = "Assistente de Escrita";
              description =
                  "Pronto para criar textos incríveis. Cole o texto que deseja melhorar ou descreva o que precisa.";
              suggestions = [
                "Crie um post para Instagram.",
                "Revise minha bio profissional.",
                "Escreva uma mensagem de promoção.",
              ];
              break;
            default:
              // Persona não encontrada
              return const Scaffold(body: Center(child: Text("Persona de IA não encontrada")));
          }

          // Atualiza o retorno para incluir suggestedPrompts
          return GenericChatScreen(
            title: title,
            personaDescription: description,
            personaKey: personaKey!,
            suggestedPrompts: suggestions, // Passa as sugestões
          );
        },
      ),

      // === NEW PREMIUM FEATURES (Sprint Nov 2025) ===

      // Chat Room Screen (WhatsApp-style direct messaging)
      GoRoute(
        path: '/chat-room/:chatId/:otherUserId/:otherUserName',
        builder: (context, state) {
          final chatId = state.pathParameters['chatId'];
          final otherUserId = state.pathParameters['otherUserId'];
          final otherUserName = state.pathParameters['otherUserName'];
          final otherUserAvatar = state.uri.queryParameters['avatar'];

          if (chatId == null || otherUserId == null || otherUserName == null) {
            return const Scaffold(body: Center(child: Text('Erro: Informações da sala de chat incompletas')));
          }

          return ChatRoomScreen(
            chatId: chatId,
            otherUserId: otherUserId,
            otherUserName: otherUserName,
            otherUserAvatar: otherUserAvatar,
          );
        },
      ),

      // Payment Screen (PIX, Credit Card, Wallet)
      GoRoute(
        path: '/payment/:amount/:description',
        builder: (context, state) {
          final amountStr = state.pathParameters['amount'];
          final description = state.pathParameters['description'] ?? 'Pagamento';
          final bookingId = state.uri.queryParameters['bookingId'];

          final amount = double.tryParse(amountStr ?? '0') ?? 0.0;

          if (amount <= 0) {
            return const Scaffold(body: Center(child: Text('Erro: Valor de pagamento inválido')));
          }

          return PaymentScreen(amount: amount, description: description, bookingId: bookingId);
        },
      ),

      // Business Intelligence Dashboard
      GoRoute(
        path: '/bi-dashboard',
        builder: (context, state) {
          // Obtém o barberId do usuário logado
          final currentProfile = ref.read(currentUserProfileProvider).value;
          final barberId = currentProfile?.userId ?? 'default';

          return BIDashboardScreen(barberId: barberId);
        },
      ),

      // Accessibility Settings (Voice control, High contrast, etc.)
      GoRoute(path: '/accessibility-settings', builder: (context, state) => const AccessibilitySettingsScreen()),

      // === END NEW PREMIUM FEATURES ===
    ],
  );
}
