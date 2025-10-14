// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_generator_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para geração de documentos legais usando Claude 3.5 Sonnet

@ProviderFor(ContractGenerator)
const contractGeneratorProvider = ContractGeneratorProvider._();

/// Controller para geração de documentos legais usando Claude 3.5 Sonnet
final class ContractGeneratorProvider
    extends $AsyncNotifierProvider<ContractGenerator, String?> {
  /// Controller para geração de documentos legais usando Claude 3.5 Sonnet
  const ContractGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contractGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contractGeneratorHash();

  @$internal
  @override
  ContractGenerator create() => ContractGenerator();
}

String _$contractGeneratorHash() => r'ae70cd7e6addd5499995d3dc76a3be7bda1852a9';

/// Controller para geração de documentos legais usando Claude 3.5 Sonnet

abstract class _$ContractGenerator extends $AsyncNotifier<String?> {
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
