// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userMatches)
const userMatchesProvider = UserMatchesProvider._();

final class UserMatchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MatchEntity>>,
          List<MatchEntity>,
          Stream<List<MatchEntity>>
        >
    with
        $FutureModifier<List<MatchEntity>>,
        $StreamProvider<List<MatchEntity>> {
  const UserMatchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userMatchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userMatchesHash();

  @$internal
  @override
  $StreamProviderElement<List<MatchEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MatchEntity>> create(Ref ref) {
    return userMatches(ref);
  }
}

String _$userMatchesHash() => r'554d368dd73af7a9c3ac7eca1ee91bba23d84268';

@ProviderFor(matchesCount)
const matchesCountProvider = MatchesCountProvider._();

final class MatchesCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  const MatchesCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchesCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchesCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return matchesCount(ref);
  }
}

String _$matchesCountHash() => r'c155006a2719f403eb6f1aa3228cf1d813ad2b95';

@ProviderFor(MatchController)
const matchControllerProvider = MatchControllerProvider._();

final class MatchControllerProvider
    extends $AsyncNotifierProvider<MatchController, void> {
  const MatchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchControllerHash();

  @$internal
  @override
  MatchController create() => MatchController();
}

String _$matchControllerHash() => r'207d8d70d43e1097f7aa3732b60c68ac22bf337a';

abstract class _$MatchController extends $AsyncNotifier<void> {
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
