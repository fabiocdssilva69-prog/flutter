// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swipe_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SwipeController)
const swipeControllerProvider = SwipeControllerProvider._();

final class SwipeControllerProvider
    extends $AsyncNotifierProvider<SwipeController, void> {
  const SwipeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swipeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swipeControllerHash();

  @$internal
  @override
  SwipeController create() => SwipeController();
}

String _$swipeControllerHash() => r'fc1240e9058ab8c31e4340599be9cfaaaaef9520';

abstract class _$SwipeController extends $AsyncNotifier<void> {
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
