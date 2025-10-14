import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barbergo_app/src/core/providers/repository_providers.dart';
import 'package:barbergo_app/src/domain/entities/enums.dart';

final currentUserIdProvider = StreamProvider<String?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

final currentAccountTypeProvider = StreamProvider<AccountType?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.accountTypeChanges();
});
