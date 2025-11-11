// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository para Settings, Notifications, Support, etc

@ProviderFor(systemRepository)
const systemRepositoryProvider = SystemRepositoryProvider._();

/// Repository para Settings, Notifications, Support, etc

final class SystemRepositoryProvider
    extends
        $FunctionalProvider<
          SystemRepository,
          SystemRepository,
          SystemRepository
        >
    with $Provider<SystemRepository> {
  /// Repository para Settings, Notifications, Support, etc
  const SystemRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemRepositoryHash();

  @$internal
  @override
  $ProviderElement<SystemRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SystemRepository create(Ref ref) {
    return systemRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemRepository>(value),
    );
  }
}

String _$systemRepositoryHash() => r'e06a343df8a9393a7c662c3f69326114e04d608c';
