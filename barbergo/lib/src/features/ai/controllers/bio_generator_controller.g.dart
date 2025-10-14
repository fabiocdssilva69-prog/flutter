// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bio_generator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para geração automática de Bio profissional usando IA

@ProviderFor(BioGenerator)
const bioGeneratorProvider = BioGeneratorProvider._();

/// Controller para geração automática de Bio profissional usando IA
final class BioGeneratorProvider
    extends $AsyncNotifierProvider<BioGenerator, String?> {
  /// Controller para geração automática de Bio profissional usando IA
  const BioGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bioGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bioGeneratorHash();

  @$internal
  @override
  BioGenerator create() => BioGenerator();
}

String _$bioGeneratorHash() => r'3e8591de494823dd42e03b5e08345685f1b7845f';

/// Controller para geração automática de Bio profissional usando IA

abstract class _$BioGenerator extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
