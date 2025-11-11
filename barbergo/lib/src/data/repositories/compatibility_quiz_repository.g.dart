// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compatibility_quiz_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository para Compatibility Quiz

@ProviderFor(compatibilityQuizRepository)
const compatibilityQuizRepositoryProvider =
    CompatibilityQuizRepositoryProvider._();

/// Repository para Compatibility Quiz

final class CompatibilityQuizRepositoryProvider
    extends
        $FunctionalProvider<
          CompatibilityQuizRepository,
          CompatibilityQuizRepository,
          CompatibilityQuizRepository
        >
    with $Provider<CompatibilityQuizRepository> {
  /// Repository para Compatibility Quiz
  const CompatibilityQuizRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compatibilityQuizRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compatibilityQuizRepositoryHash();

  @$internal
  @override
  $ProviderElement<CompatibilityQuizRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompatibilityQuizRepository create(Ref ref) {
    return compatibilityQuizRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompatibilityQuizRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompatibilityQuizRepository>(value),
    );
  }
}

String _$compatibilityQuizRepositoryHash() =>
    r'79d5ae2217e4080107728c318e2cb4570dac71f5';
