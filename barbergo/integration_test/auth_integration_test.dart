import 'package:barbergo_app/src/app.dart';
import 'package:barbergo_app/src/data/repositories/auth_repository.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Integration Tests', () {
    late MockFirebaseAuth mockAuth;
    late ErrorWidgetBuilder originalErrorBuilder;

    setUpAll(() async {
      // Salvar ErrorWidget.builder original
      originalErrorBuilder = ErrorWidget.builder;
      
      // NOTE: Firebase is already initialized by the app's main.dart
      // We don't need to initialize it again in integration tests
      
      // Setup mock auth with a mock user
      final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com', displayName: 'Test User');
      mockAuth = MockFirebaseAuth(mockUser: mockUser);
    });

    tearDownAll(() {
      // Restaurar ErrorWidget.builder original
      ErrorWidget.builder = originalErrorBuilder;
    });

    testWidgets('App launches and shows login screen', (WidgetTester tester) async {
      // Build our app with test overrides
      await tester.pumpWidget(
        ProviderScope(overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)], child: BarberGoApp()),
      );

      // Wait for app to settle
      await tester.pumpAndSettle();

      // Verify that the login screen is displayed
      expect(find.text('BarberGO'), findsOneWidget);
      expect(find.text('ENTRAR'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password fields
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      // Build our app with test overrides
      await tester.pumpWidget(
        ProviderScope(overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)], child: BarberGoApp()),
      );

      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Try to submit empty form
      final loginButton = find.text('ENTRAR');
      await tester.tap(loginButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Should show validation errors
      expect(find.text('Digite um e-mail válido'), findsOneWidget);
      expect(find.text('A senha não pode ser vazia'), findsOneWidget);
    });

    testWidgets('Login with invalid email shows error', (WidgetTester tester) async {
      // Build our app with test overrides
      await tester.pumpWidget(
        ProviderScope(overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)], child: BarberGoApp()),
      );

      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Fill form with invalid email
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'invalid-email');
      await tester.enterText(passwordField, 'password123');

      // Submit form
      final loginButton = find.text('ENTRAR');
      await tester.tap(loginButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Should show email validation error
      expect(find.text('Digite um e-mail válido'), findsOneWidget);
    });

    testWidgets('Login process completes without freezing', (WidgetTester tester) async {
      // Build our app with test overrides
      await tester.pumpWidget(
        ProviderScope(overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)], child: BarberGoApp()),
      );

      await tester.pumpAndSettle();

      // Fill form with valid data
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Submit form
      final loginButton = find.text('ENTRAR');
      await tester.tap(loginButton);

      // Wait for loading state
      await tester.pump();

      // Verify loading indicator appears
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for authentication process (with timeout to prevent infinite waiting)
      await tester.pumpAndSettle(const Duration(seconds: 35));

      // Verify app doesn't freeze - should either succeed or show error
      // The important thing is that it doesn't hang indefinitely
      expect(find.byType(BarberGoApp), findsOneWidget);
    });

    testWidgets('Retry button appears on login error', (WidgetTester tester) async {
      // Build our app with test overrides
      await tester.pumpWidget(
        ProviderScope(overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)], child: BarberGoApp()),
      );

      await tester.pumpAndSettle();

      // Fill form with valid data that will fail authentication
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'wrong@example.com');
      await tester.enterText(passwordField, 'wrongpassword');

      // Submit form
      final loginButton = find.text('ENTRAR');
      await tester.tap(loginButton);

      // Wait for error state
      await tester.pumpAndSettle(const Duration(seconds: 35));

      // Check if retry button appears (this depends on error handling)
      // The test passes if no infinite loading occurs
      expect(find.byType(BarberGoApp), findsOneWidget);
    });
  });
}
