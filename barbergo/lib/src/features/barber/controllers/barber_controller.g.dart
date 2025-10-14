// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barber_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myApplicationsStream)
const myApplicationsStreamProvider = MyApplicationsStreamProvider._();

final class MyApplicationsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApplicationEntity>>,
          List<ApplicationEntity>,
          Stream<List<ApplicationEntity>>
        >
    with
        $FutureModifier<List<ApplicationEntity>>,
        $StreamProvider<List<ApplicationEntity>> {
  const MyApplicationsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myApplicationsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myApplicationsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<ApplicationEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApplicationEntity>> create(Ref ref) {
    return myApplicationsStream(ref);
  }
}

String _$myApplicationsStreamHash() =>
    r'7f60f6b43cb4675fbfc530de7a14665a45e93a4d';
