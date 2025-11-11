// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'management_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vacancyDetailsStream)
const vacancyDetailsStreamProvider = VacancyDetailsStreamFamily._();

final class VacancyDetailsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<VacancyEntity?>,
          VacancyEntity?,
          Stream<VacancyEntity?>
        >
    with $FutureModifier<VacancyEntity?>, $StreamProvider<VacancyEntity?> {
  const VacancyDetailsStreamProvider._({
    required VacancyDetailsStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'vacancyDetailsStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vacancyDetailsStreamHash();

  @override
  String toString() {
    return r'vacancyDetailsStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<VacancyEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VacancyEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return vacancyDetailsStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VacancyDetailsStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vacancyDetailsStreamHash() =>
    r'69d4845a908ce750c3fed4c8b383a0930ffe9e18';

final class VacancyDetailsStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<VacancyEntity?>, String> {
  const VacancyDetailsStreamFamily._()
    : super(
        retry: null,
        name: r'vacancyDetailsStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VacancyDetailsStreamProvider call(String vacancyId) =>
      VacancyDetailsStreamProvider._(argument: vacancyId, from: this);

  @override
  String toString() => r'vacancyDetailsStreamProvider';
}

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
    r'a51a6d775a4a2184335f3c1a85bf2974813dc5ab';

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

@ProviderFor(userProfileStream)
const userProfileStreamProvider = UserProfileStreamFamily._();

final class UserProfileStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileEntity?>,
          ProfileEntity?,
          Stream<ProfileEntity?>
        >
    with $FutureModifier<ProfileEntity?>, $StreamProvider<ProfileEntity?> {
  const UserProfileStreamProvider._({
    required UserProfileStreamFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileStreamProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileStreamHash();

  @override
  String toString() {
    return r'userProfileStreamProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ProfileEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ProfileEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return userProfileStream(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileStreamProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileStreamHash() => r'db579f336f78ef4a9947105ce30c43667b43a27b';

final class UserProfileStreamFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ProfileEntity?>, String> {
  const UserProfileStreamFamily._()
    : super(
        retry: null,
        name: r'userProfileStreamProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileStreamProvider call(String userId) =>
      UserProfileStreamProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProfileStreamProvider';
}

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

String _$myVacanciesStreamHash() => r'5c8362838fd8b8bd7de664e1886b3cda2163e87d';

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
    r'9c9f03f68a3d92db86037a4c3808c7beb4a05944';

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
