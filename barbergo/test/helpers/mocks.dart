/// Mock classes for testing
///
/// This file contains all mock implementations used across the test suite.
/// Uses mocktail for creating mocks of Firebase and application classes.
library;

import 'package:barbergo_app/src/core/services/logger_service.dart';
import 'package:barbergo_app/src/data/datasources/firestore_service.dart';
import 'package:barbergo_app/src/data/repositories/auth_repository.dart';
import 'package:barbergo_app/src/data/repositories/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

// ============================================================================
// Mocks para classes externas (Firebase)
// ============================================================================

/// Mock do FirebaseAuth para testes de autenticação
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Mock do FirebaseFirestore para testes de banco de dados
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

/// Mock do usuário Firebase
class MockUser extends Mock implements User {}

/// Mock do UserCredential retornado após login/registro
class MockUserCredential extends Mock implements UserCredential {}

/// Mock do DocumentReference do Firestore
class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

/// Mock do DocumentSnapshot do Firestore
class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

/// Mock do CollectionReference do Firestore
class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

/// Mock do QuerySnapshot do Firestore
class MockQuerySnapshot extends Mock implements QuerySnapshot<Map<String, dynamic>> {}

/// Mock do Query do Firestore
class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

// ============================================================================
// Mocks para nossas próprias classes (Repositories e Services)
// ============================================================================

/// Mock do AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock do ProfileRepository
class MockProfileRepository extends Mock implements ProfileRepository {}

/// Mock do FirestoreService
class MockFirestoreService extends Mock implements FirestoreService {}

/// Mock do LoggerService
class MockLoggerService extends Mock implements LoggerService {}
