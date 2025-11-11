// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direct_message_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DirectMessageController)
const directMessageControllerProvider = DirectMessageControllerFamily._();

final class DirectMessageControllerProvider
    extends
        $AsyncNotifierProvider<DirectMessageController, DirectMessageState> {
  const DirectMessageControllerProvider._({
    required DirectMessageControllerFamily super.from,
    required ChatRoomEntity super.argument,
  }) : super(
         retry: null,
         name: r'directMessageControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$directMessageControllerHash();

  @override
  String toString() {
    return r'directMessageControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DirectMessageController create() => DirectMessageController();

  @override
  bool operator ==(Object other) {
    return other is DirectMessageControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$directMessageControllerHash() =>
    r'6dd779f79e6cc0246fc3ee554c0e10d0f2c7d693';

final class DirectMessageControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DirectMessageController,
          AsyncValue<DirectMessageState>,
          DirectMessageState,
          FutureOr<DirectMessageState>,
          ChatRoomEntity
        > {
  const DirectMessageControllerFamily._()
    : super(
        retry: null,
        name: r'directMessageControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DirectMessageControllerProvider call(ChatRoomEntity room) =>
      DirectMessageControllerProvider._(argument: room, from: this);

  @override
  String toString() => r'directMessageControllerProvider';
}

abstract class _$DirectMessageController
    extends $AsyncNotifier<DirectMessageState> {
  late final _$args = ref.$arg as ChatRoomEntity;
  ChatRoomEntity get room => _$args;

  FutureOr<DirectMessageState> build(ChatRoomEntity room);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<DirectMessageState>, DirectMessageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DirectMessageState>, DirectMessageState>,
              AsyncValue<DirectMessageState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
