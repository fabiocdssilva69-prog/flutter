import 'package:barbergo_app/src/core/providers/repository_providers.dart';
import 'package:barbergo_app/src/domain/entities/application_entity.dart';
import 'package:barbergo_app/src/domain/entities/enums.dart';
import 'package:barbergo_app/src/domain/entities/profile_entity.dart';
import 'package:barbergo_app/src/domain/entities/vacancy_entity.dart';
import 'package:barbergo_app/src/features/auth/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final barbershopApplicationsProvider = StreamProvider<List<ApplicationEntity>>((
  ref,
) {
  final userIdAsync = ref.watch(currentUserIdProvider);
  return userIdAsync.when(
    data: (userId) {
      if (userId == null) {
        return const Stream<List<ApplicationEntity>>.empty();
      }
      final applicationsRepository = ref.watch(applicationsRepositoryProvider);
      return applicationsRepository.watchApplicationsForBarbershop(userId);
    },
    loading: () => const Stream<List<ApplicationEntity>>.empty(),
    error: (error, stackTrace) =>
        Stream<List<ApplicationEntity>>.error(error, stackTrace),
  );
});

class ApplicationDetails {
  ApplicationDetails({
    required this.application,
    required this.barberProfile,
    required this.vacancy,
  });

  final ApplicationEntity application;
  final ProfileEntity? barberProfile;
  final VacancyEntity? vacancy;

  String get barberName => barberProfile?.displayName ?? 'Barbeiro sem nome';

  String get vacancyTitle => vacancy?.title ?? 'Vaga indisponível';

  String get formattedcreatedAt {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(application.createdAt);
  }
}

final applicationDetailsProvider =
    FutureProvider.family<ApplicationDetails, ApplicationEntity>((
      ref,
      application,
    ) async {
      final profileRepository = ref.watch(profileRepositoryProvider);
      final vacancyRepository = ref.watch(vacancyRepositoryProvider);

      final barberProfile = await profileRepository.getProfileByUserId(
        application.barberId,
      );
      final vacancy = await vacancyRepository.getVacancyById(
        application.vacancyId,
      );

      return ApplicationDetails(
        application: application,
        barberProfile: barberProfile,
        vacancy: vacancy,
      );
    });

final isBarbershopAccountProvider = Provider<bool>((ref) {
  final accountTypeAsync = ref.watch(currentAccountTypeProvider);
  return accountTypeAsync.maybeWhen(
    data: (accountType) => accountType == AccountType.barbershop,
    orElse: () => false,
  );
});
