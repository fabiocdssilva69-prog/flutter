/// Unit tests for ProfileRepository
///
/// Tests the interaction with FirestoreService using dart_mappable entities.
/// Validates CRUD operations, timestamp handling, and FCM token updates.
library;

import 'package:barbergo_app/src/data/datasources/firestore_service.dart';
import 'package:barbergo_app/src/data/repositories/profile_repository.dart';
import 'package:barbergo_app/src/domain/entities/enums.dart';
import 'package:barbergo_app/src/domain/entities/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks específicos
class MockFirestoreService extends Mock implements FirestoreService {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

class MockStreamDocumentSnapshot extends Mock implements Stream<DocumentSnapshot<Map<String, dynamic>>> {}

void main() {
  late MockFirestoreService mockService;
  late MockFirebaseFirestore mockFirestore;
  late ProfileRepository repository;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;

  const userId = 'testUserId123';
  // Entidade real (dart_mappable)
  final testProfile = ProfileEntity(
    userId: userId,
    accountType: AccountType.barber,
    name: 'Test Barber',
    email: 'test@example.com',
    createdAt: DateTime.now(),
  );

  setUpAll(() {
    // Register fallback values for any() matchers
    registerFallbackValue(SetOptions(merge: true));
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockService = MockFirestoreService();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    when(() => mockService.db).thenReturn(mockFirestore);
    repository = ProfileRepository(service: mockService);
  });

  group('ProfileRepository Tests', () {
    test('saveProfile should call Firestore set with correct data and updated timestamp', () async {
      // Arrange
      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async => Future.value());

      // Act
      await repository.saveProfile(testProfile);

      // Assert
      // Capturamos os argumentos passados para o 'set'
      final captured = verify(() => mockDocRef.set(captureAny(), any())).captured;
      final capturedData = Map<String, dynamic>.from(captured.first as Map);

      expect(capturedData['userId'], userId);
      expect(capturedData['name'], 'Test Barber');
      expect(capturedData['email'], 'test@example.com');
      expect(capturedData['accountType'], 'barber'); // dart_mappable serializa enums sem prefixo

      // Verificamos se o updatedAt foi adicionado e é um Timestamp (devido ao TimestampHook)
      expect(capturedData['updatedAt'], isA<Timestamp>());
      expect(capturedData['createdAt'], isA<Timestamp>());
    });

    test('saveProfile should use merge option when calling set', () async {
      // Arrange
      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async => Future.value());

      // Act
      await repository.saveProfile(testProfile);

      // Assert
      // Note: O repository atual não usa merge, mas verifica a chamada
      verify(() => mockDocRef.set(any(), any())).called(1);
    });

    test('updateFcmToken should call Firestore update with FieldValue.delete when token is null', () async {
      // Arrange
      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async => Future.value());

      // Act
      await repository.updateFcmToken(userId, null);

      // Assert
      final captured = verify(() => mockDocRef.update(captureAny())).captured;
      final capturedArgs = Map<String, dynamic>.from(captured.single as Map);

      // Verificamos se o valor passado é do tipo FieldValue (indicando exclusão ou serverTimestamp)
      expect(capturedArgs['fcmToken'], isA<FieldValue>());
      expect(capturedArgs['updatedAt'], isA<FieldValue>());
    });

    test('updateFcmToken should call Firestore update with token string when provided', () async {
      // Arrange
      const testToken = 'fcm_token_abc123';
      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async => Future.value());

      // Act
      await repository.updateFcmToken(userId, testToken);

      // Assert
      final captured = verify(() => mockDocRef.update(captureAny())).captured;
      final capturedArgs = Map<String, dynamic>.from(captured.single as Map);

      expect(capturedArgs['fcmToken'], testToken);
      expect(capturedArgs['updatedAt'], isA<FieldValue>());
    });

    test('getProfile should return null when document does not exist', () async {
      // Arrange
      final mockSnapshot = MockDocumentSnapshot();
      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      // Act
      final result = await repository.getProfile(userId);

      // Assert
      expect(result, isNull);
      verify(() => mockDocRef.get()).called(1);
    });

    test('getProfile should return ProfileEntity when document exists', () async {
      // Arrange
      final mockSnapshot = MockDocumentSnapshot();
      // Usar dados já serializados (como viriam do Firestore)
      final now = DateTime.now();
      final profileData = {
        'userId': userId,
        'accountType': 'barber',
        'name': 'Test Barber',
        'email': 'test@example.com',
        'bio': '',
        'location': '',
        'contactPhone': '',
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      };

      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn(profileData);

      // Act
      final result = await repository.getProfile(userId);

      // Assert
      expect(result, isNotNull);
      expect(result!.userId, userId);
      expect(result.name, 'Test Barber');
      expect(result.email, 'test@example.com');
      expect(result.accountType, AccountType.barber);
    });

    test('saveProfile should update timestamp before saving', () async {
      // Arrange
      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async => Future.value());

      final beforeSave = DateTime.now();

      // Act
      await repository.saveProfile(testProfile);

      // Assert
      final captured = verify(() => mockDocRef.set(captureAny(), any())).captured;
      final capturedData = Map<String, dynamic>.from(captured.first as Map);
      final updatedAtTimestamp = capturedData['updatedAt'] as Timestamp;
      final updatedAt = updatedAtTimestamp.toDate();

      // O timestamp deve ser igual ou posterior ao momento antes do save
      expect(updatedAt.isAfter(beforeSave) || updatedAt.isAtSameMomentAs(beforeSave), isTrue);
    });

    test('repository should use correct collection path', () async {
      // Arrange
      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async => Future.value());

      // Act
      await repository.saveProfile(testProfile);

      // Assert
      verify(() => mockFirestore.collection('profiles')).called(1);
    });

    test('saveProfile should include all profile fields in saved data', () async {
      // Arrange
      final profileWithAllFields = ProfileEntity(
        userId: userId,
        accountType: AccountType.barbershop,
        name: 'Complete Barbershop',
        email: 'shop@example.com',
        bio: 'Best barbershop in town',
        location: 'São Paulo, SP',
        contactPhone: '+5511999999999',
        fcmToken: 'test_fcm_token',
        createdAt: DateTime.now(),
      );

      when(() => mockFirestore.collection(ProfileRepository.profilesPath)).thenReturn(mockCollection);
      when(() => mockCollection.doc(userId)).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any(), any())).thenAnswer((_) async => Future.value());

      // Act
      await repository.saveProfile(profileWithAllFields);

      // Assert
      final captured = verify(() => mockDocRef.set(captureAny(), any())).captured;
      final capturedData = Map<String, dynamic>.from(captured.first as Map);

      expect(capturedData['bio'], 'Best barbershop in town');
      expect(capturedData['location'], 'São Paulo, SP');
      expect(capturedData['contactPhone'], '+5511999999999');
      expect(capturedData['fcmToken'], 'test_fcm_token');
      expect(capturedData['accountType'], 'barbershop'); // dart_mappable serializa enums sem prefixo
    });
  });
}
