/// Example test demonstrating the use of test helpers
///
/// This file shows how to use mocks in tests.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  group('Test Infrastructure - Mocks', () {
    late MockAuthRepository mockAuthRepository;
    late MockLoggerService mockLoggerService;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockLoggerService = MockLoggerService();
    });

    test('should create mock instances', () {
      // Verify mocks can be instantiated
      expect(mockAuthRepository, isNotNull);
      expect(mockLoggerService, isNotNull);
    });

    test('should stub method calls with mocktail', () {
      // Arrange: Configure the mock behavior
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      // Act: Use the mock
      final currentUser = mockAuthRepository.currentUser;

      // Assert: Verify the result
      expect(currentUser, isNull);

      // Verify: Confirm the method was called
      verify(() => mockAuthRepository.currentUser).called(1);
    });

    test('should verify mock interactions', () {
      // Arrange
      when(() => mockLoggerService.logEvent(any(), parameters: any(named: 'parameters'))).thenReturn(null);

      // Act
      mockLoggerService.logEvent('test_event', parameters: {'key': 'value'});

      // Assert
      verify(() => mockLoggerService.logEvent('test_event', parameters: {'key': 'value'})).called(1);
    });

    test('should verify no unexpected interactions', () {
      // Arrange
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      // Act
      mockAuthRepository.currentUser;

      // Assert: Verify only currentUser was called
      verify(() => mockAuthRepository.currentUser).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
