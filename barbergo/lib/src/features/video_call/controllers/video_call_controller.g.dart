// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_call_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VideoCallController)
const videoCallControllerProvider = VideoCallControllerProvider._();

final class VideoCallControllerProvider
    extends $AsyncNotifierProvider<VideoCallController, VideoCallSession?> {
  const VideoCallControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoCallControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoCallControllerHash();

  @$internal
  @override
  VideoCallController create() => VideoCallController();
}

String _$videoCallControllerHash() =>
    r'e2553521fc912e7173b82f91af9b7d83f2181c03';

abstract class _$VideoCallController extends $AsyncNotifier<VideoCallSession?> {
  FutureOr<VideoCallSession?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<VideoCallSession?>, VideoCallSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VideoCallSession?>, VideoCallSession?>,
              AsyncValue<VideoCallSession?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
