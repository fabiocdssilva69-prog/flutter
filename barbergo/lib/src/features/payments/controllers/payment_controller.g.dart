// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaymentController)
const paymentControllerProvider = PaymentControllerProvider._();

final class PaymentControllerProvider
    extends
        $AsyncNotifierProvider<PaymentController, List<PaymentTransaction>> {
  const PaymentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentControllerHash();

  @$internal
  @override
  PaymentController create() => PaymentController();
}

String _$paymentControllerHash() => r'dc94d3974e6b8dc4bcdf11d48414dc635cc967a9';

abstract class _$PaymentController
    extends $AsyncNotifier<List<PaymentTransaction>> {
  FutureOr<List<PaymentTransaction>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<PaymentTransaction>>,
              List<PaymentTransaction>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PaymentTransaction>>,
                List<PaymentTransaction>
              >,
              AsyncValue<List<PaymentTransaction>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(savedCards)
const savedCardsProvider = SavedCardsFamily._();

final class SavedCardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SavedCard>>,
          List<SavedCard>,
          FutureOr<List<SavedCard>>
        >
    with $FutureModifier<List<SavedCard>>, $FutureProvider<List<SavedCard>> {
  const SavedCardsProvider._({
    required SavedCardsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'savedCardsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savedCardsHash();

  @override
  String toString() {
    return r'savedCardsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SavedCard>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SavedCard>> create(Ref ref) {
    final argument = this.argument as String;
    return savedCards(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedCardsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savedCardsHash() => r'399027d6d12a1e7cdd26df8c131d7174af9f1960';

final class SavedCardsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SavedCard>>, String> {
  const SavedCardsFamily._()
    : super(
        retry: null,
        name: r'savedCardsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SavedCardsProvider call(String userId) =>
      SavedCardsProvider._(argument: userId, from: this);

  @override
  String toString() => r'savedCardsProvider';
}
