// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_feed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocialFeedController)
const socialFeedControllerProvider = SocialFeedControllerProvider._();

final class SocialFeedControllerProvider
    extends $AsyncNotifierProvider<SocialFeedController, List<SocialPost>> {
  const SocialFeedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialFeedControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialFeedControllerHash();

  @$internal
  @override
  SocialFeedController create() => SocialFeedController();
}

String _$socialFeedControllerHash() =>
    r'9208612222d8b55f62d300963adca79fb438a4d1';

abstract class _$SocialFeedController extends $AsyncNotifier<List<SocialPost>> {
  FutureOr<List<SocialPost>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<SocialPost>>, List<SocialPost>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SocialPost>>, List<SocialPost>>,
              AsyncValue<List<SocialPost>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
