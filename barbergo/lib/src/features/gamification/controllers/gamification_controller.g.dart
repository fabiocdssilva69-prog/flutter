// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GamificationController)
const gamificationControllerProvider = GamificationControllerProvider._();

final class GamificationControllerProvider
    extends $AsyncNotifierProvider<GamificationController, GamificationStats> {
  const GamificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gamificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gamificationControllerHash();

  @$internal
  @override
  GamificationController create() => GamificationController();
}

String _$gamificationControllerHash() =>
    r'12f9d8dda2da7994d5f0512b710758caee0d2288';

abstract class _$GamificationController
    extends $AsyncNotifier<GamificationStats> {
  FutureOr<GamificationStats> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<GamificationStats>, GamificationStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GamificationStats>, GamificationStats>,
              AsyncValue<GamificationStats>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
