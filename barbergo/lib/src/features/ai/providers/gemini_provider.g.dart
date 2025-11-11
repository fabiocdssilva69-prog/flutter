// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider para o modelo Gemini Pro
///
/// IMPORTANTE: Configure a API key no arquivo .env:
/// - Adicione GOOGLE_GEMINI_API_KEY=sua_chave no arquivo .env
/// - O arquivo .env está no .gitignore (seguro)

@ProviderFor(geminiProModel)
const geminiProModelProvider = GeminiProModelProvider._();

/// Provider para o modelo Gemini Pro
///
/// IMPORTANTE: Configure a API key no arquivo .env:
/// - Adicione GOOGLE_GEMINI_API_KEY=sua_chave no arquivo .env
/// - O arquivo .env está no .gitignore (seguro)

final class GeminiProModelProvider
    extends
        $FunctionalProvider<GenerativeModel, GenerativeModel, GenerativeModel>
    with $Provider<GenerativeModel> {
  /// Provider para o modelo Gemini Pro
  ///
  /// IMPORTANTE: Configure a API key no arquivo .env:
  /// - Adicione GOOGLE_GEMINI_API_KEY=sua_chave no arquivo .env
  /// - O arquivo .env está no .gitignore (seguro)
  const GeminiProModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiProModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiProModelHash();

  @$internal
  @override
  $ProviderElement<GenerativeModel> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GenerativeModel create(Ref ref) {
    return geminiProModel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerativeModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerativeModel>(value),
    );
  }
}

String _$geminiProModelHash() => r'9c0bfee73c0d7f1274249c52b3a55c3e24444d13';

/// Provider para o modelo Gemini Pro Vision (análise de imagens)

@ProviderFor(geminiProVisionModel)
const geminiProVisionModelProvider = GeminiProVisionModelProvider._();

/// Provider para o modelo Gemini Pro Vision (análise de imagens)

final class GeminiProVisionModelProvider
    extends
        $FunctionalProvider<GenerativeModel, GenerativeModel, GenerativeModel>
    with $Provider<GenerativeModel> {
  /// Provider para o modelo Gemini Pro Vision (análise de imagens)
  const GeminiProVisionModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiProVisionModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiProVisionModelHash();

  @$internal
  @override
  $ProviderElement<GenerativeModel> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GenerativeModel create(Ref ref) {
    return geminiProVisionModel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerativeModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerativeModel>(value),
    );
  }
}

String _$geminiProVisionModelHash() =>
    r'c7e933b0249dbff4bb18d7a70234f0bc193c328d';
