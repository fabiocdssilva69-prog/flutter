// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provedor do VacancyRepository.

@ProviderFor(vacancyRepository)
const vacancyRepositoryProvider = VacancyRepositoryProvider._();

/// Provedor do VacancyRepository.

final class VacancyRepositoryProvider
    extends
        $FunctionalProvider<
          VacancyRepository,
          VacancyRepository,
          VacancyRepository
        >
    with $Provider<VacancyRepository> {
  /// Provedor do VacancyRepository.
  const VacancyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vacancyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vacancyRepositoryHash();

  @$internal
  @override
  $ProviderElement<VacancyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VacancyRepository create(Ref ref) {
    return vacancyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VacancyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VacancyRepository>(value),
    );
  }
}

String _$vacancyRepositoryHash() => r'7a75f3cdb848309c3aeca6300a63f1eab1d933cd';

/// StreamProvider que retorna todas as vagas ativas em tempo real.

@ProviderFor(activeVacancies)
const activeVacanciesProvider = ActiveVacanciesProvider._();

/// StreamProvider que retorna todas as vagas ativas em tempo real.

final class ActiveVacanciesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VacancyEntity>>,
          List<VacancyEntity>,
          Stream<List<VacancyEntity>>
        >
    with
        $FutureModifier<List<VacancyEntity>>,
        $StreamProvider<List<VacancyEntity>> {
  /// StreamProvider que retorna todas as vagas ativas em tempo real.
  const ActiveVacanciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeVacanciesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeVacanciesHash();

  @$internal
  @override
  $StreamProviderElement<List<VacancyEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VacancyEntity>> create(Ref ref) {
    return activeVacancies(ref);
  }
}

String _$activeVacanciesHash() => r'd0e9d3f7c230f4a400ff8371ba98050cb7328de2';

/// StreamProvider que retorna as vagas de uma barbearia específica.

@ProviderFor(barbershopVacancies)
const barbershopVacanciesProvider = BarbershopVacanciesFamily._();

/// StreamProvider que retorna as vagas de uma barbearia específica.

final class BarbershopVacanciesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VacancyEntity>>,
          List<VacancyEntity>,
          Stream<List<VacancyEntity>>
        >
    with
        $FutureModifier<List<VacancyEntity>>,
        $StreamProvider<List<VacancyEntity>> {
  /// StreamProvider que retorna as vagas de uma barbearia específica.
  const BarbershopVacanciesProvider._({
    required BarbershopVacanciesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'barbershopVacanciesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$barbershopVacanciesHash();

  @override
  String toString() {
    return r'barbershopVacanciesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<VacancyEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VacancyEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return barbershopVacancies(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BarbershopVacanciesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$barbershopVacanciesHash() =>
    r'c2a42b6fbba565f51888b72871b0ba0c33f11f6e';

/// StreamProvider que retorna as vagas de uma barbearia específica.

final class BarbershopVacanciesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<VacancyEntity>>, String> {
  const BarbershopVacanciesFamily._()
    : super(
        retry: null,
        name: r'barbershopVacanciesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// StreamProvider que retorna as vagas de uma barbearia específica.

  BarbershopVacanciesProvider call(String barbershopId) =>
      BarbershopVacanciesProvider._(argument: barbershopId, from: this);

  @override
  String toString() => r'barbershopVacanciesProvider';
}
