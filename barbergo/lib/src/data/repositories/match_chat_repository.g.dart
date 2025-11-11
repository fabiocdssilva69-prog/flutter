// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(matchChatRepository)
const matchChatRepositoryProvider = MatchChatRepositoryProvider._();

final class MatchChatRepositoryProvider
    extends
        $FunctionalProvider<
          MatchChatRepository,
          MatchChatRepository,
          MatchChatRepository
        >
    with $Provider<MatchChatRepository> {
  const MatchChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'matchChatRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$matchChatRepositoryHash();

  @$internal
  @override
  $ProviderElement<MatchChatRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MatchChatRepository create(Ref ref) {
    return matchChatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MatchChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MatchChatRepository>(value),
    );
  }
}

String _$matchChatRepositoryHash() =>
    r'a69ac7df23fa95d564bef209009239b5e1c818b0';
