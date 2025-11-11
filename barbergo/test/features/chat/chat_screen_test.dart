import 'package:barbergo_app/src/data/models/message_entity.dart';
import 'package:barbergo_app/src/data/repositories/match_chat_repository.dart';
import 'package:barbergo_app/src/domain/entities/profile_entity.dart';
import 'package:barbergo_app/src/features/auth/data/auth_repository.dart';
import 'package:barbergo_app/src/features/chat/presentation/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Gerar mocks: flutter pub run build_runner build
@GenerateMocks([firebase_auth.User])
import 'chat_screen_test.mocks.dart';

void main() {
  group('ChatScreen Widget Tests', () {
    late MockUser mockUser;
    late ProfileEntity mockOtherUser;

    setUp(() {
      mockUser = MockUser();
      when(mockUser.uid).thenReturn('test_user_id');

      mockOtherUser = ProfileEntity(
        userId: 'other_user_id',
        name: 'João Silva',
        email: 'joao@test.com',
        phoneNumber: '11999999999',
        accountType: 'barber',
        avatarUrl: 'https://example.com/avatar.jpg',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
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
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('Usuário não autenticado'), findsOneWidget);
    });

    testWidgets('Deve exibir CircularProgressIndicator enquanto carrega mensagens', (WidgetTester tester) async {
      // Arrange: Mock stream que demora a responder
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchChatRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchChatRepository();
            when(mockRepo.watchChatMessages('test_chat_id')).thenAnswer(
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
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Deve exibir mensagem quando chat está vazio', (WidgetTester tester) async {
      // Arrange: Mock stream retornando lista vazia
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchChatRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchChatRepository();
            when(mockRepo.watchChatMessages('test_chat_id')).thenAnswer((_) => Stream.value([]));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Nenhuma mensagem ainda. Diga oi! 👋'), findsOneWidget);
    });

    testWidgets('Deve exibir lista de mensagens quando há dados', (WidgetTester tester) async {
      // Arrange: Mock messages
      final now = DateTime.now();
      final mockMessages = [
        MessageEntity(
          messageId: 'msg1',
          chatId: 'test_chat_id',
          senderId: 'other_user_id',
          text: 'Olá! Como vai?',
          createdAt: now.subtract(const Duration(minutes: 5)),
        ),
        MessageEntity(
          messageId: 'msg2',
          chatId: 'test_chat_id',
          senderId: 'test_user_id',
          text: 'Oi! Tudo bem, e você?',
          createdAt: now,
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchChatRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchChatRepository();
            when(mockRepo.watchChatMessages('test_chat_id')).thenAnswer((_) => Stream.value(mockMessages));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Olá! Como vai?'), findsOneWidget);
      expect(find.text('Oi! Tudo bem, e você?'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Deve exibir AppBar com avatar e nome do outro usuário', (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchChatRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchChatRepository();
            when(mockRepo.watchChatMessages('test_chat_id')).thenAnswer((_) => Stream.value([]));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('João Silva'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Deve ter TextField e botão de enviar', (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchChatRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchChatRepository();
            when(mockRepo.watchChatMessages('test_chat_id')).thenAnswer((_) => Stream.value([]));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Digite uma mensagem...'), findsOneWidget);
    });

    testWidgets('Deve enviar mensagem ao clicar no botão', (WidgetTester tester) async {
      // Arrange
      final mockRepo = MockMatchChatRepository();
      when(mockRepo.watchChatMessages('test_chat_id')).thenAnswer((_) => Stream.value([]));
      when(
        mockRepo.sendMessage(chatId: 'test_chat_id', senderId: 'test_user_id', text: anyNamed('text')),
      ).thenAnswer((_) async => {});

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWith((ref) {
            final mockAuth = MockAuthRepository();
            when(mockAuth.currentUser).thenReturn(mockUser);
            return mockAuth;
          }),
          matchChatRepositoryProvider.overrideWith((ref) => mockRepo),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Digite uma mensagem
      await tester.enterText(find.byType(TextField), 'Olá, tudo bem?');
      await tester.pumpAndSettle();

      // Clique no botão de enviar
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Assert
      verify(mockRepo.sendMessage(chatId: 'test_chat_id', senderId: 'test_user_id', text: 'Olá, tudo bem?')).called(1);
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
          matchChatRepositoryProvider.overrideWith((ref) {
            final mockRepo = MockMatchChatRepository();
            when(
              mockRepo.watchChatMessages('test_chat_id'),
            ).thenAnswer((_) => Stream.error(Exception('Erro de teste')));
            return mockRepo;
          }),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ChatScreen(chatId: 'test_chat_id', otherUser: mockOtherUser),
          ),
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

class MockMatchChatRepository extends Mock implements MatchChatRepository {}
