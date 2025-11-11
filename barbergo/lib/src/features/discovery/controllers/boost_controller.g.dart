// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boost_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para gerenciar o sistema de Boost
/// Boost: aparecer no topo dos resultados de discovery por 30 minutos
/// Compra: 5 boosts por R$ 9,90 via Stripe

@ProviderFor(BoostController)
const boostControllerProvider = BoostControllerProvider._();

/// Controller para gerenciar o sistema de Boost
/// Boost: aparecer no topo dos resultados de discovery por 30 minutos
/// Compra: 5 boosts por R$ 9,90 via Stripe
final class BoostControllerProvider
    extends $AsyncNotifierProvider<BoostController, void> {
  /// Controller para gerenciar o sistema de Boost
  /// Boost: aparecer no topo dos resultados de discovery por 30 minutos
  /// Compra: 5 boosts por R$ 9,90 via Stripe
  const BoostControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'boostControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$boostControllerHash();

  @$internal
  @override
  BoostController create() => BoostController();
}

String _$boostControllerHash() => r'788503a3cda862c21580cf0437a93f3c157db0e2';

/// Controller para gerenciar o sistema de Boost
/// Boost: aparecer no topo dos resultados de discovery por 30 minutos
/// Compra: 5 boosts por R$ 9,90 via Stripe

abstract class _$BoostController extends $AsyncNotifier<void> {
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
