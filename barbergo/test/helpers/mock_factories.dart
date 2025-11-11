/// Mock factories for creating test data
/// 
/// This file contains factory methods for creating mock data objects
/// used in tests throughout the project.
library;

import 'package:barbergo_app/src/data/models/profile.dart';
import 'package:barbergo_app/src/data/models/vacancy.dart';
import 'package:barbergo_app/src/data/models/application.dart';

/// Factory for creating mock Profile objects
class MockProfileFactory {
  static Profile barber({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? city,
  }) {
    return Profile(
      userId: id ?? 'test_barber_id',
      name: name ?? 'João Silva',
      email: email ?? 'joao@example.com',
      accountType: AccountType.barber,
      phoneNumber: phoneNumber ?? '11999999999',
      photoUrl: photoUrl,
      city: city ?? 'São Paulo',
      state: 'SP',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Profile barbershop({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    String? city,
  }) {
    return Profile(
      userId: id ?? 'test_barbershop_id',
      name: name ?? 'Barbearia Elite',
      email: email ?? 'barbearia@example.com',
      accountType: AccountType.barbershop,
      phoneNumber: phoneNumber ?? '11988888888',
      photoUrl: photoUrl,
      city: city ?? 'São Paulo',
      state: 'SP',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Factory for creating mock Vacancy objects
class MockVacancyFactory {
  static Vacancy vacancy({
    String? id,
    String? barbershopId,
    String? barbershopName,
    String? title,
    String? description,
    VacancyType? type,
    double? salary,
    String? city,
    String? state,
  }) {
    return Vacancy(
      id: id ?? 'test_vacancy_id',
      barbershopId: barbershopId ?? 'test_barbershop_id',
      barbershopName: barbershopName ?? 'Barbearia Elite',
      title: title ?? 'Barbeiro Profissional',
      description: description ?? 'Vaga para barbeiro com experiência',
      type: type ?? VacancyType.clt,
      salary: salary ?? 3000.0,
      city: city ?? 'São Paulo',
      state: state ?? 'SP',
      requirements: ['Experiência mínima de 2 anos', 'Cortes modernos'],
      benefits: ['Vale transporte', 'Vale refeição'],
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Vacancy freelanceVacancy({
    String? id,
    String? barbershopId,
  }) {
    return vacancy(
      id: id,
      barbershopId: barbershopId,
      type: VacancyType.freelance,
      title: 'Barbeiro Freelancer',
      salary: 150.0,
    );
  }

  static Vacancy commissionVacancy({
    String? id,
    String? barbershopId,
  }) {
    return vacancy(
      id: id,
      barbershopId: barbershopId,
      type: VacancyType.commission,
      title: 'Barbeiro por Comissão',
      description: 'Comissão de 50% por corte',
    );
  }
}

/// Factory for creating mock Application objects
class MockApplicationFactory {
  static Application application({
    String? id,
    String? vacancyId,
    String? barberId,
    ApplicationStatus? status,
  }) {
    return Application(
      id: id ?? 'test_application_id',
      vacancyId: vacancyId ?? 'test_vacancy_id',
      barberId: barberId ?? 'test_barber_id',
      status: status ?? ApplicationStatus.pending,
      appliedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Application pendingApplication({
    String? id,
    String? vacancyId,
    String? barberId,
  }) {
    return application(
      id: id,
      vacancyId: vacancyId,
      barberId: barberId,
      status: ApplicationStatus.pending,
    );
  }

  static Application acceptedApplication({
    String? id,
    String? vacancyId,
    String? barberId,
  }) {
    return application(
      id: id,
      vacancyId: vacancyId,
      barberId: barberId,
      status: ApplicationStatus.accepted,
    );
  }

  static Application rejectedApplication({
    String? id,
    String? vacancyId,
    String? barberId,
  }) {
    return application(
      id: id,
      vacancyId: vacancyId,
      barberId: barberId,
      status: ApplicationStatus.rejected,
    );
  }
}
