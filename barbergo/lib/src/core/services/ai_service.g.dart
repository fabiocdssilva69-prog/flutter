// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiService)
const aiServiceProvider = AiServiceProvider._();

final class AiServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<AiService>,
          AiService,
          FutureOr<AiService>
        >
    with $FutureModifier<AiService>, $FutureProvider<AiService> {
  const AiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiServiceHash();

  @$internal
  @override
  $FutureProviderElement<AiService> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AiService> create(Ref ref) {
    return aiService(ref);
  }
}

String _$aiServiceHash() => r'5dc7b6060ba486756d7d0793ad0eeab06bb9e117';
