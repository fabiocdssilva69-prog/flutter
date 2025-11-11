// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inboxStream)
const inboxStreamProvider = InboxStreamProvider._();

final class InboxStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatRoomEntity>>,
          List<ChatRoomEntity>,
          Stream<List<ChatRoomEntity>>
        >
    with
        $FutureModifier<List<ChatRoomEntity>>,
        $StreamProvider<List<ChatRoomEntity>> {
  const InboxStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inboxStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inboxStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ChatRoomEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatRoomEntity>> create(Ref ref) {
    return inboxStream(ref);
  }
}

String _$inboxStreamHash() => r'23f2990013ce93c390d7da990756e08c5f1908c3';
