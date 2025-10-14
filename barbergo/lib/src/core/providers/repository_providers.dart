import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barbergo_app/src/domain/repositories/applications_repository.dart';
import 'package:barbergo_app/src/domain/repositories/auth_repository.dart';
import 'package:barbergo_app/src/domain/repositories/profile_repository.dart';
import 'package:barbergo_app/src/domain/repositories/vacancy_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('authRepositoryProvider precisa ser sobrescrito.');
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  throw UnimplementedError(
    'profileRepositoryProvider precisa ser sobrescrito.',
  );
});

final vacancyRepositoryProvider = Provider<VacancyRepository>((ref) {
  throw UnimplementedError(
    'vacancyRepositoryProvider precisa ser sobrescrito.',
  );
});

final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) {
  throw UnimplementedError(
    'applicationsRepositoryProvider precisa ser sobrescrito.',
  );
});
