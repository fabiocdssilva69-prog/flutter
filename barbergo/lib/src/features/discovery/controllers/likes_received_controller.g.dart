// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likes_received_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para gerenciar a funcionalidade "Ver Quem Curtiu Você"
/// Premium Feature - Free users veem quantidade, Premium veem perfis completos

@ProviderFor(LikesReceivedController)
const likesReceivedControllerProvider = LikesReceivedControllerProvider._();

/// Controller para gerenciar a funcionalidade "Ver Quem Curtiu Você"
/// Premium Feature - Free users veem quantidade, Premium veem perfis completos
final class LikesReceivedControllerProvider
    extends $AsyncNotifierProvider<LikesReceivedController, List<SwipeEntity>> {
  /// Controller para gerenciar a funcionalidade "Ver Quem Curtiu Você"
  /// Premium Feature - Free users veem quantidade, Premium veem perfis completos
  const LikesReceivedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likesReceivedControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likesReceivedControllerHash();

  @$internal
  @override
  LikesReceivedController create() => LikesReceivedController();
}

String _$likesReceivedControllerHash() =>
    r'2d205e02549403a1a1c4e8907da2f4b0a72205f3';

/// Controller para gerenciar a funcionalidade "Ver Quem Curtiu Você"
/// Premium Feature - Free users veem quantidade, Premium veem perfis completos

abstract class _$LikesReceivedController
    extends $AsyncNotifier<List<SwipeEntity>> {
  FutureOr<List<SwipeEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<SwipeEntity>>, List<SwipeEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SwipeEntity>>, List<SwipeEntity>>,
              AsyncValue<List<SwipeEntity>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
