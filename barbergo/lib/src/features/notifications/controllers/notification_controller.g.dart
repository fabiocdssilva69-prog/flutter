// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userNotificationsStream)
const userNotificationsStreamProvider = UserNotificationsStreamProvider._();

final class UserNotificationsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationEntity>>,
          List<NotificationEntity>,
          Stream<List<NotificationEntity>>
        >
    with
        $FutureModifier<List<NotificationEntity>>,
        $StreamProvider<List<NotificationEntity>> {
  const UserNotificationsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userNotificationsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userNotificationsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<NotificationEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NotificationEntity>> create(Ref ref) {
    return userNotificationsStream(ref);
  }
}

String _$userNotificationsStreamHash() =>
    r'0934c8c4232fdea86ee216d9b20f99bdb92fd3f1';

@ProviderFor(unreadNotificationCount)
const unreadNotificationCountProvider = UnreadNotificationCountProvider._();

final class UnreadNotificationCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const UnreadNotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadNotificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadNotificationCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadNotificationCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadNotificationCountHash() =>
    r'aba5da0c3f25598f06e13f30f9e25895d3b6bdb4';

@ProviderFor(NotificationController)
const notificationControllerProvider = NotificationControllerProvider._();

final class NotificationControllerProvider
    extends $AsyncNotifierProvider<NotificationController, void> {
  const NotificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationControllerHash();

  @$internal
  @override
  NotificationController create() => NotificationController();
}

String _$notificationControllerHash() =>
    r'4eb24a6e894122beae812e5c9330de898fa285f9';

abstract class _$NotificationController extends $AsyncNotifier<void> {
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
