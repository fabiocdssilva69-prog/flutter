// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(imageUploadService)
const imageUploadServiceProvider = ImageUploadServiceProvider._();

final class ImageUploadServiceProvider
    extends
        $FunctionalProvider<
          ImageUploadService,
          ImageUploadService,
          ImageUploadService
        >
    with $Provider<ImageUploadService> {
  const ImageUploadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageUploadServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageUploadServiceHash();

  @$internal
  @override
  $ProviderElement<ImageUploadService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageUploadService create(Ref ref) {
    return imageUploadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageUploadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageUploadService>(value),
    );
  }
}

String _$imageUploadServiceHash() =>
    r'3d7fa712dd713179543357eed18e766b3e94c5a2';
