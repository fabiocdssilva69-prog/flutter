// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userPortfolio)
const userPortfolioProvider = UserPortfolioProvider._();

final class UserPortfolioProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PortfolioItemEntity>>,
          List<PortfolioItemEntity>,
          Stream<List<PortfolioItemEntity>>
        >
    with
        $FutureModifier<List<PortfolioItemEntity>>,
        $StreamProvider<List<PortfolioItemEntity>> {
  const UserPortfolioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPortfolioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPortfolioHash();

  @$internal
  @override
  $StreamProviderElement<List<PortfolioItemEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PortfolioItemEntity>> create(Ref ref) {
    return userPortfolio(ref);
  }
}

String _$userPortfolioHash() => r'77608691ff2e52325d75e1e528784a27cfee2dd6';

@ProviderFor(portfolio)
const portfolioProvider = PortfolioFamily._();

final class PortfolioProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PortfolioItemEntity>>,
          List<PortfolioItemEntity>,
          Stream<List<PortfolioItemEntity>>
        >
    with
        $FutureModifier<List<PortfolioItemEntity>>,
        $StreamProvider<List<PortfolioItemEntity>> {
  const PortfolioProvider._({
    required PortfolioFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'portfolioProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$portfolioHash();

  @override
  String toString() {
    return r'portfolioProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PortfolioItemEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PortfolioItemEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return portfolio(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PortfolioProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$portfolioHash() => r'cdb059f72c1619dda8ed710ae88cd4ec7287f092';

final class PortfolioFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PortfolioItemEntity>>, String> {
  const PortfolioFamily._()
    : super(
        retry: null,
        name: r'portfolioProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PortfolioProvider call(String userId) =>
      PortfolioProvider._(argument: userId, from: this);

  @override
  String toString() => r'portfolioProvider';
}

@ProviderFor(PortfolioController)
const portfolioControllerProvider = PortfolioControllerProvider._();

final class PortfolioControllerProvider
    extends $AsyncNotifierProvider<PortfolioController, void> {
  const PortfolioControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portfolioControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portfolioControllerHash();

  @$internal
  @override
  PortfolioController create() => PortfolioController();
}

String _$portfolioControllerHash() =>
    r'0d0576ad301bc51c9a767d255668cdfb6ce1fa1c';

abstract class _$PortfolioController extends $AsyncNotifier<void> {
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
