// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_matching_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller de Matching Inteligente usando GPT-4

@ProviderFor(SmartMatching)
const smartMatchingProvider = SmartMatchingProvider._();

/// Controller de Matching Inteligente usando GPT-4
final class SmartMatchingProvider
    extends $AsyncNotifierProvider<SmartMatching, List<MatchScore>> {
  /// Controller de Matching Inteligente usando GPT-4
  const SmartMatchingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smartMatchingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smartMatchingHash();

  @$internal
  @override
  SmartMatching create() => SmartMatching();
}

String _$smartMatchingHash() => r'fce342c44138641110ddcf8bb8220b52e354dd0b';

/// Controller de Matching Inteligente usando GPT-4

abstract class _$SmartMatching extends $AsyncNotifier<List<MatchScore>> {
  FutureOr<List<MatchScore>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<MatchScore>>, List<MatchScore>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MatchScore>>, List<MatchScore>>,
              AsyncValue<List<MatchScore>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
