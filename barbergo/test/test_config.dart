import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barbergo_app/src/data/repositories/auth_repository.dart';

// Override provider for testing
final testFirebaseAuthProvider = Provider<MockFirebaseAuth>((ref) {
  final mockUser = MockUser(
    uid: 'test-uid',
    email: 'test@example.com',
    displayName: 'Test User',
  );
  return MockFirebaseAuth(mockUser: mockUser);
});

// Override the auth repository to use mock auth
final testAuthRepositoryProvider = Provider<AuthRepository>((ref) {
  final mockAuth = ref.watch(testFirebaseAuthProvider);
  return AuthRepository(mockAuth);
});

// Container with test overrides
final testProviderContainer = ProviderContainer(
  overrides: [
    firebaseAuthProvider.overrideWithProvider(testFirebaseAuthProvider),
    authRepositoryProvider.overrideWithProvider(testAuthRepositoryProvider),
  ],
);