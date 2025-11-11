import 'package:barbergo_app/src/domain/entities/profile_entity.dart';
import 'package:barbergo_app/src/features/discovery/controllers/discovery_controller.dart';
import 'package:barbergo_app/src/features/discovery/controllers/swipe_controller.dart';
import 'package:barbergo_app/src/features/discovery/presentation/swipe_screen.dart';
import 'package:barbergo_app/src/domain/entities/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SwipeScreen Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Deve exibir CircularProgressIndicator quando loading', (WidgetTester tester) async {
      // Arrange: Mock provider retornando loading
      final container = ProviderContainer(
        overrides: [
          discoverProfilesProvider.overrideWith((ref) {
            return Stream.value([]); // Stream nunca emite se quiser loading infinito
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SwipeScreen()),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Deve exibir erro quando falha ao carregar perfis', (WidgetTester tester) async {
      // Arrange: Mock provider retornando erro
      final container = ProviderContainer(
        overrides: [
          discoverProfilesProvider.overrideWith((ref) {
            return Stream.error(Exception('Erro de teste'));
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SwipeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erro ao carregar perfis'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('Deve exibir mensagem quando não há perfis disponíveis', (WidgetTester tester) async {
      // Arrange: Mock provider retornando lista vazia
      final container = ProviderContainer(
        overrides: [discoverProfilesProvider.overrideWith((ref) => Stream.value([]))],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SwipeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Nenhum perfil disponível'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('Tente aumentar o raio de busca'), findsOneWidget);
    });

    testWidgets('Deve exibir cards de perfil quando há dados', (WidgetTester tester) async {
      // Arrange: Mock profiles
      final mockProfiles = [
        ProfileEntity(
          userId: '1',
          name: 'João Silva',
          email: 'joao@test.com',
          phoneNumber: '11999999999',
          accountType: AccountType.barber,
          bio: 'Barbeiro há 5 anos',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProfileEntity(
          userId: '2',
          name: 'Maria Santos',
          email: 'maria@test.com',
          phoneNumber: '11888888888',
          accountType: AccountType.barber,
          bio: 'Especialista em cortes',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          discoverProfilesProvider.overrideWith((ref) => Stream.value(mockProfiles)),
          // Mock swipeController para não fazer chamadas reais
          swipeControllerProvider.overrideWith((ref) => const AsyncValue.data(null)),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SwipeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('Barbeiro há 5 anos'), findsOneWidget);
    });

    testWidgets('Deve ter botões de like e dislike', (WidgetTester tester) async {
      // Arrange
      final mockProfiles = [
        ProfileEntity(
          userId: '1',
          name: 'João Silva',
          email: 'joao@test.com',
          phoneNumber: '11999999999',
          accountType: AccountType.barber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          discoverProfilesProvider.overrideWith((ref) => Stream.value(mockProfiles)),
          swipeControllerProvider.overrideWith((ref) => const AsyncValue.data(null)),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SwipeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.close), findsOneWidget); // Botão dislike
      expect(find.byIcon(Icons.favorite), findsOneWidget); // Botão like
      expect(find.byType(FloatingActionButton), findsNWidgets(2));
    });

    testWidgets('Deve exibir AppBar com título "Descobrir"', (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [discoverProfilesProvider.overrideWith((ref) => Stream.value([]))],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SwipeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Descobrir'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Deve exibir SnackBar ao dar like em um perfil', (WidgetTester tester) async {
      // Arrange
      final mockProfiles = [
        ProfileEntity(
          userId: '1',
          name: 'João Silva',
          email: 'joao@test.com',
          phoneNumber: '11999999999',
          accountType: AccountType.barber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          discoverProfilesProvider.overrideWith((ref) => Stream.value(mockProfiles)),
          swipeControllerProvider.overrideWith((ref) => const AsyncValue.data(null)),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SwipeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap no botão de like
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('❤️ Você curtiu João Silva'), findsOneWidget);
    });
  });
}

