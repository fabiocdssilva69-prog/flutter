import 'package:barbergo_app/src/data/repositories/auth_repository.dart';
import 'package:barbergo_app/src/features/auth/controllers/auth_controller.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController Validation Tests', () {
    test('signIn with invalid email fails validation', () async {
      // Act
      final controller = container.read(authControllerProvider.notifier);
      final result = await controller.signIn('invalid-email', 'password123');

      // Assert
      expect(result, false);
      final state = container.read(authControllerProvider);
      expect(state.hasError, true);
      expect(state.error.toString(), contains('Email inválido'));
    });

    test('signIn with empty password fails validation', () async {
      // Act
      final controller = container.read(authControllerProvider.notifier);
      final result = await controller.signIn('test@example.com', '');

      // Assert
      expect(result, false);
      final state = container.read(authControllerProvider);
      expect(state.hasError, true);
      expect(
        state.error.toString(),
        contains('Email e senha são obrigatórios'),
      );
    });

    test('signIn with empty email fails validation', () async {
      // Act
      final controller = container.read(authControllerProvider.notifier);
      final result = await controller.signIn('', 'password123');

      // Assert
      expect(result, false);
      final state = container.read(authControllerProvider);
      expect(state.hasError, true);
      expect(
        state.error.toString(),
        contains('Email e senha são obrigatórios'),
      );
    });

    test('signUp with short password fails validation', () async {
      // Act
      final controller = container.read(authControllerProvider.notifier);
      final result = await controller.signUp('test@example.com', '123');

      // Assert
      expect(result, false);
      final state = container.read(authControllerProvider);
      expect(state.hasError, true);
      expect(
        state.error.toString(),
        contains('Senha deve ter pelo menos 6 caracteres'),
      );
    });

    test('signUp with invalid email fails validation', () async {
      // Act
      final controller = container.read(authControllerProvider.notifier);
      final result = await controller.signUp('invalid-email', 'password123');

      // Assert
      expect(result, false);
      final state = container.read(authControllerProvider);
      expect(state.hasError, true);
      expect(state.error.toString(), contains('Email inválido'));
    });

    test('signUp with empty fields fails validation', () async {
      // Act
      final controller = container.read(authControllerProvider.notifier);
      final result = await controller.signUp('', '');

      // Assert
      expect(result, false);
      final state = container.read(authControllerProvider);
      expect(state.hasError, true);
      expect(
        state.error.toString(),
        contains('Email e senha são obrigatórios'),
      );
    });
  });
}
