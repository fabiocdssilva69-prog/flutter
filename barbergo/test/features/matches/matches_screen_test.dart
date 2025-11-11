import 'package:barbergo_app/src/data/models/match_entity.dart';
import 'package:barbergo_app/src/data/repositories/match_repository.dart';
import 'package:barbergo_app/src/data/repositories/profile_repository.dart';
import 'package:barbergo_app/src/domain/entities/profile_entity.dart';
import 'package:barbergo_app/src/features/auth/data/auth_repository.dart';
import 'package:barbergo_app/src/features/matches/presentation/matches_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Gerar mocks: flutter pub run build_runner build
@GenerateMocks([firebase_auth.User])
import 'matches_screen_test.mocks.dart';

void main() {
  group('MatchesScreen Widget Tests', () {
    late MockUser mockUser;

    setUp(() {
      mockUser = MockUser();
      when(mockUser.uid).thenReturn('test_user_id');
    });

    testWidgets('Deve exibir mensagem quando usuário não está autenticado', (WidgetTester tester) async {
      // Arrange: Mock auth sem usuário
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final auth = AuthRepository(auth: firebase_auth.FirebaseAuth.instance);
            return auth;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MatchesScreen()),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Usuário não autenticado'), findsOneWidget);
    });

    testWidgets('Deve exibir CircularProgressIndicator enquanto carrega', (WidgetTester tester) async {
      // Arrange: Mock stream que demora a responder
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchRepository();
            when(mockRepo.watchUserMatches('test_user_id')).thenAnswer(
              (_) => Stream.value([]).map((event) {
                // Nunca emite, simula loading infinito
                return event;
              }),
            );
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MatchesScreen()),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Deve exibir mensagem quando não há matches', (WidgetTester tester) async {
      // Arrange: Mock stream retornando lista vazia
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchRepository();
            when(mockRepo.watchUserMatches('test_user_id')).thenAnswer((_) => Stream.value([]));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MatchesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Nenhum match ainda'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('Continue dando likes para encontrar matches!'), findsOneWidget);
    });

    testWidgets('Deve exibir lista de matches quando há dados', (WidgetTester tester) async {
      // Arrange: Mock matches e profiles
      final now = DateTime.now();
      final mockMatches = [
        MatchEntity(
          matchId: 'match1',
          user1Id: 'test_user_id',
          user2Id: 'other_user_1',
          createdAt: now,
          lastMessageAt: now,
          lastMessage: 'Olá!',
        ),
        MatchEntity(
          matchId: 'match2',
          user1Id: 'test_user_id',
          user2Id: 'other_user_2',
          createdAt: now.subtract(const Duration(hours: 1)),
          lastMessageAt: now.subtract(const Duration(hours: 1)),
          lastMessage: 'Tudo bem?',
        ),
      ];

      final mockProfiles = {
        'other_user_1': ProfileEntity(
          userId: 'other_user_1',
          name: 'João Silva',
          email: 'joao@test.com',
          phoneNumber: '11999999999',
          accountType: 'barber',
          createdAt: now,
          updatedAt: now,
        ),
        'other_user_2': ProfileEntity(
          userId: 'other_user_2',
          name: 'Maria Santos',
          email: 'maria@test.com',
          phoneNumber: '11888888888',
          accountType: 'client',
          createdAt: now,
          updatedAt: now,
        ),
      };

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchRepository();
            when(mockRepo.watchUserMatches('test_user_id')).thenAnswer((_) => Stream.value(mockMatches));
            return mockRepo;
          }),
          profileRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockProfileRepository();
            when(mockRepo.getProfile('other_user_1')).thenAnswer((_) async => mockProfiles['other_user_1']!);
            when(mockRepo.getProfile('other_user_2')).thenAnswer((_) async => mockProfiles['other_user_2']!);
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MatchesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('Maria Santos'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Deve exibir AppBar com título "Matches"', (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchRepository();
            when(mockRepo.watchUserMatches('test_user_id')).thenAnswer((_) => Stream.value([]));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MatchesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Matches'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Deve exibir erro quando stream falha', (WidgetTester tester) async {
      // Arrange: Mock stream retornando erro
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchRepository();
            when(mockRepo.watchUserMatches('test_user_id')).thenAnswer((_) => Stream.error(Exception('Erro de teste')));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: MatchesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Erro:'), findsOneWidget);
    });
  });
}

// Mock classes (precisam ser geradas com build_runner)
class MockAuthRepository extends Mock implements AuthRepository {}

class MockMatchRepository extends Mock implements MatchRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}
