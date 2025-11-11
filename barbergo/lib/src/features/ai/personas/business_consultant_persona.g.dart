// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_consultant_persona.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provedor para acessar a Persona de Consultoria de Negócios
///
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).

@ProviderFor(businessConsultantPersona)
const businessConsultantPersonaProvider = BusinessConsultantPersonaProvider._();

/// Provedor para acessar a Persona de Consultoria de Negócios
///
/// O Provedor da Persona agora também se torna assíncrono (FutureProvider).

final class BusinessConsultantPersonaProvider
    extends
        $FunctionalProvider<
          AsyncValue<BusinessConsultantPersona>,
          BusinessConsultantPersona,
          FutureOr<BusinessConsultantPersona>
        >
    with
        $FutureModifier<BusinessConsultantPersona>,
        $FutureProvider<BusinessConsultantPersona> {
  /// Provedor para acessar a Persona de Consultoria de Negócios
  ///
  /// O Provedor da Persona agora também se torna assíncrono (FutureProvider).
  const BusinessConsultantPersonaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessConsultantPersonaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessConsultantPersonaHash();

  @$internal
  @override
  $FutureProviderElement<BusinessConsultantPersona> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BusinessConsultantPersona> create(Ref ref) {
    return businessConsultantPersona(ref);
  }
}

String _$businessConsultantPersonaHash() =>
    r'85c59dac8405bf9a99d4916b3275732bb9f32a72';
