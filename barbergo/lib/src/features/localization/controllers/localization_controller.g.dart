// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalizationController)
const localizationControllerProvider = LocalizationControllerProvider._();

final class LocalizationControllerProvider
    extends $NotifierProvider<LocalizationController, Locale> {
  const LocalizationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localizationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localizationControllerHash();

  @$internal
  @override
  LocalizationController create() => LocalizationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localizationControllerHash() =>
    r'c279225987a57e116cc413a795992ad75770061a';

abstract class _$LocalizationController extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
