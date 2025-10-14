// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myVacanciesStream)
const myVacanciesStreamProvider = MyVacanciesStreamProvider._();

final class MyVacanciesStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VacancyEntity>>,
          List<VacancyEntity>,
          Stream<List<VacancyEntity>>
        >
    with
        $FutureModifier<List<VacancyEntity>>,
        $StreamProvider<List<VacancyEntity>> {
  const MyVacanciesStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myVacanciesStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myVacanciesStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<VacancyEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VacancyEntity>> create(Ref ref) {
    return myVacanciesStream(ref);
  }
}

String _$myVacanciesStreamHash() => r'704416cb487f80a9a3a6de525952149e2a64d4ba';

@ProviderFor(applicationsForVacancyStream)
const applicationsForVacancyStreamProvider =
    ApplicationsForVacancyStreamFamily._();

final class ApplicationsForVacancyStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationEntity>>,
          List<ApplicationEntity>,
          Stream<List<ApplicationEntity>>
        >
    with
        $FutureModifier<List<ApplicationEntity>>,
        $StreamProvider<List<ApplicationEntity>> {
  const ApplicationsForVacancyStreamProvider._({
    required ApplicationsForVacancyStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'applicationsForVacancyStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$applicationsForVacancyStreamHash();

  @override
  String toString() {
    return r'applicationsForVacancyStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ApplicationEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApplicationEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return applicationsForVacancyStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApplicationsForVacancyStreamProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$applicationsForVacancyStreamHash() =>
    r'6bb74347ecda377cf74c4873e427fa7b03641063';

final class ApplicationsForVacancyStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ApplicationEntity>>, String> {
  const ApplicationsForVacancyStreamFamily._()
    : super(
        retry: null,
        name: r'applicationsForVacancyStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ApplicationsForVacancyStreamProvider call(String vacancyId) =>
      ApplicationsForVacancyStreamProvider._(argument: vacancyId, from: this);

  @override
  String toString() => r'applicationsForVacancyStreamProvider';
}

@ProviderFor(ManagementController)
const managementControllerProvider = ManagementControllerProvider._();

final class ManagementControllerProvider
    extends $AsyncNotifierProvider<ManagementController, void> {
  const ManagementControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managementControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managementControllerHash();

  @$internal
  @override
  ManagementController create() => ManagementController();
}

String _$managementControllerHash() =>
    r'76f3b613a735c64e025b04d4819c6cc7759a63db';

abstract class _$ManagementController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
