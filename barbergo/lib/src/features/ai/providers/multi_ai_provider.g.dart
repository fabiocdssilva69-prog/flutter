// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider para o cliente OpenAI (GPT-4)

@ProviderFor(openAIClient)
const openAIClientProvider = OpenAIClientProvider._();

/// Provider para o cliente OpenAI (GPT-4)

final class OpenAIClientProvider
    extends
        $FunctionalProvider<
          openai.OpenAIClient,
          openai.OpenAIClient,
          openai.OpenAIClient
        >
    with $Provider<openai.OpenAIClient> {
  /// Provider para o cliente OpenAI (GPT-4)
  const OpenAIClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openAIClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openAIClientHash();

  @$internal
  @override
  $ProviderElement<openai.OpenAIClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  openai.OpenAIClient create(Ref ref) {
    return openAIClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(openai.OpenAIClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<openai.OpenAIClient>(value),
    );
  }
}

String _$openAIClientHash() => r'575d67b64c29036ca5a446b6e0eaaf1ddd0f73c9';

/// Provider para o cliente Anthropic (Claude)

@ProviderFor(anthropicClient)
const anthropicClientProvider = AnthropicClientProvider._();

/// Provider para o cliente Anthropic (Claude)

final class AnthropicClientProvider
    extends
        $FunctionalProvider<
          anthropic.AnthropicClient,
          anthropic.AnthropicClient,
          anthropic.AnthropicClient
        >
    with $Provider<anthropic.AnthropicClient> {
  /// Provider para o cliente Anthropic (Claude)
  const AnthropicClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'anthropicClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$anthropicClientHash();

  @$internal
  @override
  $ProviderElement<anthropic.AnthropicClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  anthropic.AnthropicClient create(Ref ref) {
    return anthropicClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(anthropic.AnthropicClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<anthropic.AnthropicClient>(value),
    );
  }
}

String _$anthropicClientHash() => r'37fc896383c56ecf74c4e3d538878d076d38a38b';

/// Serviço para GPT-4

@ProviderFor(GPTService)
const gPTServiceProvider = GPTServiceProvider._();

/// Serviço para GPT-4
final class GPTServiceProvider
    extends $AsyncNotifierProvider<GPTService, void> {
  /// Serviço para GPT-4
  const GPTServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gPTServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gPTServiceHash();

  @$internal
  @override
  GPTService create() => GPTService();
}

String _$gPTServiceHash() => r'c7cee2624750c372c4add2597ee2c7a9d671e142';

/// Serviço para GPT-4

abstract class _$GPTService extends $AsyncNotifier<void> {
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
