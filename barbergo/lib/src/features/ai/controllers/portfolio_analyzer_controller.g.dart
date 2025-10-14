// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_analyzer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para análise de portfólio usando Gemini Pro Vision

@ProviderFor(PortfolioAnalyzer)
const portfolioAnalyzerProvider = PortfolioAnalyzerProvider._();

/// Controller para análise de portfólio usando Gemini Pro Vision
final class PortfolioAnalyzerProvider
    extends $AsyncNotifierProvider<PortfolioAnalyzer, PortfolioSummary?> {
  /// Controller para análise de portfólio usando Gemini Pro Vision
  const PortfolioAnalyzerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portfolioAnalyzerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portfolioAnalyzerHash();

  @$internal
  @override
  PortfolioAnalyzer create() => PortfolioAnalyzer();
}

String _$portfolioAnalyzerHash() => r'7dadea879a42595bf230f7af38f588a11a88af0c';

/// Controller para análise de portfólio usando Gemini Pro Vision

abstract class _$PortfolioAnalyzer extends $AsyncNotifier<PortfolioSummary?> {
  FutureOr<PortfolioSummary?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<PortfolioSummary?>, PortfolioSummary?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PortfolioSummary?>, PortfolioSummary?>,
              AsyncValue<PortfolioSummary?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
