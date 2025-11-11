// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para upload e gerenciamento de mídia (Phase 1)

@ProviderFor(MediaUploadController)
const mediaUploadControllerProvider = MediaUploadControllerProvider._();

/// Controller para upload e gerenciamento de mídia (Phase 1)
final class MediaUploadControllerProvider
    extends $AsyncNotifierProvider<MediaUploadController, void> {
  /// Controller para upload e gerenciamento de mídia (Phase 1)
  const MediaUploadControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaUploadControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaUploadControllerHash();

  @$internal
  @override
  MediaUploadController create() => MediaUploadController();
}

String _$mediaUploadControllerHash() =>
    r'e4d4ab6860660af79cbada5a29c568c82c87015f';

/// Controller para upload e gerenciamento de mídia (Phase 1)

abstract class _$MediaUploadController extends $AsyncNotifier<void> {
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
