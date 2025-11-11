// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_ideas_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository para Date Ideas

@ProviderFor(dateIdeasRepository)
const dateIdeasRepositoryProvider = DateIdeasRepositoryProvider._();

/// Repository para Date Ideas

final class DateIdeasRepositoryProvider
    extends
        $FunctionalProvider<
          DateIdeasRepository,
          DateIdeasRepository,
          DateIdeasRepository
        >
    with $Provider<DateIdeasRepository> {
  /// Repository para Date Ideas
  const DateIdeasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dateIdeasRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dateIdeasRepositoryHash();

  @$internal
  @override
  $ProviderElement<DateIdeasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateIdeasRepository create(Ref ref) {
    return dateIdeasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateIdeasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateIdeasRepository>(value),
    );
  }
}

String _$dateIdeasRepositoryHash() =>
    r'a0534cda966656e7a5fd25c87c31717b3ac43973';
