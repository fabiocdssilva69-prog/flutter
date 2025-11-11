// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bi_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BIDashboardController)
const bIDashboardControllerProvider = BIDashboardControllerFamily._();

final class BIDashboardControllerProvider
    extends $AsyncNotifierProvider<BIDashboardController, BIMetrics> {
  const BIDashboardControllerProvider._({
    required BIDashboardControllerFamily super.from,
    required (String, DateTime, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'bIDashboardControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bIDashboardControllerHash();

  @override
  String toString() {
    return r'bIDashboardControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  BIDashboardController create() => BIDashboardController();

  @override
  bool operator ==(Object other) {
    return other is BIDashboardControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bIDashboardControllerHash() =>
    r'b4f8749f827b3802a67b9b8141058fd036820489';

final class BIDashboardControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          BIDashboardController,
          AsyncValue<BIMetrics>,
          BIMetrics,
          FutureOr<BIMetrics>,
          (String, DateTime, DateTime)
        > {
  const BIDashboardControllerFamily._()
    : super(
        retry: null,
        name: r'bIDashboardControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BIDashboardControllerProvider call(
    String barberId,
    DateTime startDate,
    DateTime endDate,
  ) => BIDashboardControllerProvider._(
    argument: (barberId, startDate, endDate),
    from: this,
  );

  @override
  String toString() => r'bIDashboardControllerProvider';
}

abstract class _$BIDashboardController extends $AsyncNotifier<BIMetrics> {
  late final _$args = ref.$arg as (String, DateTime, DateTime);
  String get barberId => _$args.$1;
  DateTime get startDate => _$args.$2;
  DateTime get endDate => _$args.$3;

  FutureOr<BIMetrics> build(
    String barberId,
    DateTime startDate,
    DateTime endDate,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2, _$args.$3);
    final ref = this.ref as $Ref<AsyncValue<BIMetrics>, BIMetrics>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BIMetrics>, BIMetrics>,
              AsyncValue<BIMetrics>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
