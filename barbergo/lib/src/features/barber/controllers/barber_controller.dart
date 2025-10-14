import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/application_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/application_entity.dart';

part 'barber_controller.g.dart';

// Provider que retorna stream de candidaturas do barbeiro logado
@riverpod
Stream<List<ApplicationEntity>> myApplicationsStream(
  Ref ref,
) {
  final authUser = ref.watch(authStateChangesProvider).value;
  if (authUser == null) {
    return const Stream.empty();
  }

  final repository = ref.watch(applicationRepositoryProvider);
  return repository.watchApplicationsByBarber(authUser.uid);
}
