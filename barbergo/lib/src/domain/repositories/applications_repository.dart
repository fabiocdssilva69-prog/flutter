import 'package:barbergo_app/src/domain/entities/application_entity.dart';

/// Contrato para leitura de candidaturas recebidas por uma barbearia.
abstract class ApplicationsRepository {
  Stream<List<ApplicationEntity>> watchApplicationsForBarbershop(
    String barbershopId,
  );
}
