// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_notifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SmartNotificationsController)
const smartNotificationsControllerProvider =
    SmartNotificationsControllerProvider._();

final class SmartNotificationsControllerProvider
    extends
        $AsyncNotifierProvider<
          SmartNotificationsController,
          List<NotificationSchedule>
        > {
  const SmartNotificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smartNotificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smartNotificationsControllerHash();

  @$internal
  @override
  SmartNotificationsController create() => SmartNotificationsController();
}

String _$smartNotificationsControllerHash() =>
    r'dc67e178fc8f76847d0db53ba165631d84ee4fc7';

abstract class _$SmartNotificationsController
    extends $AsyncNotifier<List<NotificationSchedule>> {
  FutureOr<List<NotificationSchedule>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<NotificationSchedule>>,
              List<NotificationSchedule>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationSchedule>>,
                List<NotificationSchedule>
              >,
              AsyncValue<List<NotificationSchedule>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
