// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accessibility_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccessibilityController)
const accessibilityControllerProvider = AccessibilityControllerProvider._();

final class AccessibilityControllerProvider
    extends $NotifierProvider<AccessibilityController, AccessibilitySettings> {
  const AccessibilityControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessibilityControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessibilityControllerHash();

  @$internal
  @override
  AccessibilityController create() => AccessibilityController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccessibilitySettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccessibilitySettings>(value),
    );
  }
}

String _$accessibilityControllerHash() =>
    r'e7388e11f5e970f857b42fc11645ec03a69be5d1';

abstract class _$AccessibilityController
    extends $Notifier<AccessibilitySettings> {
  AccessibilitySettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AccessibilitySettings, AccessibilitySettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccessibilitySettings, AccessibilitySettings>,
              AccessibilitySettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(supportedAccessibilityLanguages)
const supportedAccessibilityLanguagesProvider =
    SupportedAccessibilityLanguagesProvider._();

final class SupportedAccessibilityLanguagesProvider
    extends
        $FunctionalProvider<
          List<Map<String, String>>,
          List<Map<String, String>>,
          List<Map<String, String>>
        >
    with $Provider<List<Map<String, String>>> {
  const SupportedAccessibilityLanguagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportedAccessibilityLanguagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportedAccessibilityLanguagesHash();

  @$internal
  @override
  $ProviderElement<List<Map<String, String>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<Map<String, String>> create(Ref ref) {
    return supportedAccessibilityLanguages(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Map<String, String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Map<String, String>>>(value),
    );
  }
}

String _$supportedAccessibilityLanguagesHash() =>
    r'a7aa72345323b6eda2041bab486733dbba0f4b04';
