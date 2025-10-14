// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ApplicationController)
const applicationControllerProvider = ApplicationControllerProvider._();

final class ApplicationControllerProvider
    extends $NotifierProvider<ApplicationController, void> {
  const ApplicationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applicationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applicationControllerHash();

  @$internal
  @override
  ApplicationController create() => ApplicationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$applicationControllerHash() =>
    r'9b0ee5ee595cb54cc7eb939b438c1b2519e2b0da';

abstract class _$ApplicationController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
