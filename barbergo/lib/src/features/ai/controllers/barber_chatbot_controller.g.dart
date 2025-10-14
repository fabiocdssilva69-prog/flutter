// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barber_chatbot_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller para chatbot especializado no mundo artístico de cabelos e barbas

@ProviderFor(BarberChatbotController)
const barberChatbotControllerProvider = BarberChatbotControllerProvider._();

/// Controller para chatbot especializado no mundo artístico de cabelos e barbas
final class BarberChatbotControllerProvider
    extends $AsyncNotifierProvider<BarberChatbotController, void> {
  /// Controller para chatbot especializado no mundo artístico de cabelos e barbas
  const BarberChatbotControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barberChatbotControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barberChatbotControllerHash();

  @$internal
  @override
  BarberChatbotController create() => BarberChatbotController();
}

String _$barberChatbotControllerHash() =>
    r'623c5ea4a2998edb6ed3848f1cd5fe23bccea4d6';

/// Controller para chatbot especializado no mundo artístico de cabelos e barbas

abstract class _$BarberChatbotController extends $AsyncNotifier<void> {
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
