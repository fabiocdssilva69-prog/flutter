// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barber_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BarberDashboardController)
const barberDashboardControllerProvider = BarberDashboardControllerProvider._();

final class BarberDashboardControllerProvider
    extends $AsyncNotifierProvider<BarberDashboardController, BarberStats> {
  const BarberDashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barberDashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barberDashboardControllerHash();

  @$internal
  @override
  BarberDashboardController create() => BarberDashboardController();
}

String _$barberDashboardControllerHash() =>
    r'95014b24ab5684cbcb4cf824d4596d3db578b76c';

abstract class _$BarberDashboardController extends $AsyncNotifier<BarberStats> {
  FutureOr<BarberStats> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<BarberStats>, BarberStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BarberStats>, BarberStats>,
              AsyncValue<BarberStats>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
