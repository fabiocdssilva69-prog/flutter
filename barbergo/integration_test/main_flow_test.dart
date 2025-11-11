import 'package:barbergo_app/src/app.dart';
import 'package:barbergo_app/src/data/repositories/auth_repository.dart';
import 'package:barbergo_app/src/data/repositories/profile_repository.dart';
import 'package:barbergo_app/src/domain/entities/enums.dart';
import 'package:barbergo_app/src/domain/entities/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/helpers/mocks.dart'; // Importa os mocks

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late MockProfileRepository mockProfileRepo;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockProfileRepo = MockProfileRepository();
    mockUser = MockUser();

    // Configuração padrão: Usuário logado, sem perfil (Onboarding necessário)
    when(() => mockUser.uid).thenReturn('test_uid');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockAuthRepo.authStateChanges).thenAnswer((_) => Stream.value(mockUser));
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);
    // Simula que o perfil ainda não existe
    when(() => mockProfileRepo.watchProfile('test_uid')).thenAnswer((_) => Stream.value(null));
    // Mock necessário para o ProfileController tentar buscar o perfil existente
    when(() => mockProfileRepo.getProfile('test_uid')).thenAnswer((_) async => null);
  });

  // Função auxiliar para iniciar o app com overrides dos provedores
  Widget createTestApp() {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        profileRepositoryProvider.overrideWithValue(mockProfileRepo),
        // TODO: Mockar GeolocationService e ImageUploadService para um teste completo no futuro
      ],
      child: const BarberGoApp(), // O aplicativo principal
    );
  }

  testWidgets('Full Flow: Authenticated user without profile should be redirected to Onboarding and complete it', (
    WidgetTester tester,
  ) async {
    // 1. Inicia o App
    await tester.pumpWidget(createTestApp());
    // Espera a inicialização (SplashScreen) e a resolução do roteamento
    await tester.pumpAndSettle();

    // 2. Verifica redirecionamento para Onboarding
    // Usamos o texto que definimos no i18n (app_pt.arb)
    expect(find.text('Complete seu Cadastro'), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);

    // 3. Preenche o formulário de Onboarding
    // Seleciona o Dropdown
    await tester.tap(find.byType(DropdownButtonFormField<AccountType>));
    await tester.pumpAndSettle();
    // Toca na opção 'Barbeiro(a)' (texto do i18n)
    await tester.tap(find.text('Barbeiro(a)').last);
    await tester.pumpAndSettle();

    // Preenche os campos de texto (Usamos os labels do i18n para encontrar os campos)
    await tester.enterText(find.widgetWithText(TextFormField, 'Nome Completo ou Nome da Barbearia'), 'João Barbeiro');
    // Nota: A localização requer interação com GPS no UI real, mas aqui preenchemos manualmente para o teste passar.
    await tester.enterText(find.widgetWithText(TextFormField, 'Localização (Ex: Cidade, Estado)'), 'Minha Cidade, SC');
    await tester.enterText(find.widgetWithText(TextFormField, 'Telefone de Contato'), '123456789');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Biografia ou Descrição dos Serviços'),
      'Minha biografia detalhada.',
    );

    // 4. Salva o perfil
    // Prepara o mock para aceitar o salvamento e atualizar o stream
    final savedProfile = ProfileEntity(
      userId: 'test_uid',
      accountType: AccountType.barber,
      name: 'João Barbeiro',
      email: 'test@example.com',
      createdAt: DateTime.now(),
      location: 'Minha Cidade, SC',
    );

    // Registra o tipo ProfileEntity para o mocktail (necessário para 'any()')
    registerFallbackValue(savedProfile);

    when(() => mockProfileRepo.saveProfile(any())).thenAnswer((invocation) async {
      // Atualiza o stream simulado para refletir o perfil salvo
      when(() => mockProfileRepo.watchProfile('test_uid')).thenAnswer((_) => Stream.value(savedProfile));
      return Future.value();
    });

    // Rola para baixo para garantir que o botão esteja visível
    await tester.drag(find.byType(Form), const Offset(0, -300));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CONCLUIR CADASTRO'));
    await tester.pumpAndSettle(); // Espera a navegação e a atualização do stream

    // 5. Verifica o redirecionamento para a Home (Tela de Descoberta para Barbeiros)
    // Verifica se o texto da aba 'Descobrir' (do i18n) está presente na AppBar ou BottomNav
    expect(find.text('Descobrir'), findsWidgets);
    // Verifica se a tela de descoberta está visível
    // expect(find.byType(BarberDiscoveryView), findsOneWidget); // Pode ser necessário ajustar o Finder se a view estiver encapsulada
  });
}
