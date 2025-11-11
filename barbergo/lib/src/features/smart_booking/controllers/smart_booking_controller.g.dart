// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_booking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SmartBookingController)
const smartBookingControllerProvider = SmartBookingControllerProvider._();

final class SmartBookingControllerProvider
    extends
        $AsyncNotifierProvider<
          SmartBookingController,
          List<BookingSuggestion>
        > {
  const SmartBookingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smartBookingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smartBookingControllerHash();

  @$internal
  @override
  SmartBookingController create() => SmartBookingController();
}

String _$smartBookingControllerHash() =>
    r'aa95d335a10e471f5ff65a4b57c64be7df5cb18b';

abstract class _$SmartBookingController
    extends $AsyncNotifier<List<BookingSuggestion>> {
  FutureOr<List<BookingSuggestion>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<BookingSuggestion>>,
              List<BookingSuggestion>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<BookingSuggestion>>,
                List<BookingSuggestion>
              >,
              AsyncValue<List<BookingSuggestion>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
