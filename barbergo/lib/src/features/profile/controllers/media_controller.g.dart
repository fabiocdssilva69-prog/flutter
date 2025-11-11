// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaController)
const mediaControllerProvider = MediaControllerProvider._();

final class MediaControllerProvider
    extends $AsyncNotifierProvider<MediaController, void> {
  const MediaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaControllerHash();

  @$internal
  @override
  MediaController create() => MediaController();
}

String _$mediaControllerHash() => r'a228ab9f5643a84e394947745b67b9e393695a61';

abstract class _$MediaController extends $AsyncNotifier<void> {
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
