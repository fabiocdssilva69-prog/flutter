// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_advisor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para consultoria de negócios e análise de mercado

@ProviderFor(BusinessAdvisorController)
const businessAdvisorControllerProvider = BusinessAdvisorControllerProvider._();

/// Controller para consultoria de negócios e análise de mercado
final class BusinessAdvisorControllerProvider
    extends $AsyncNotifierProvider<BusinessAdvisorController, void> {
  /// Controller para consultoria de negócios e análise de mercado
  const BusinessAdvisorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessAdvisorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessAdvisorControllerHash();

  @$internal
  @override
  BusinessAdvisorController create() => BusinessAdvisorController();
}

String _$businessAdvisorControllerHash() =>
    r'3f1301c24f594ad1501c88ada211e446c0eed261';

/// Controller para consultoria de negócios e análise de mercado

abstract class _$BusinessAdvisorController extends $AsyncNotifier<void> {
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
