// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Serviço unificado usando apenas Google Gemini 2.0

@ProviderFor(GeminiService)
const geminiServiceProvider = GeminiServiceProvider._();

/// Serviço unificado usando apenas Google Gemini 2.0
final class GeminiServiceProvider
    extends $AsyncNotifierProvider<GeminiService, void> {
  /// Serviço unificado usando apenas Google Gemini 2.0
  const GeminiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiServiceHash();

  @$internal
  @override
  GeminiService create() => GeminiService();
}

String _$geminiServiceHash() => r'f927f0a161cbabc05c966a13a8f32750b3cda15d';

/// Serviço unificado usando apenas Google Gemini 2.0

abstract class _$GeminiService extends $AsyncNotifier<void> {
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
