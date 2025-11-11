import 'package:dart_mappable/dart_mappable.dart';

part 'enums.mapper.dart';

// Tipos de Conta
@MappableEnum()
enum AccountType { customer, barber, barbershop }

// Tipos de Vaga
@MappableEnum()
enum VacancyType {
  freelancer, // Autônomo
  clt, // Carteira Assinada (Fixo)
  commission, // Comissionado
}

// Status da Candidatura
@MappableEnum()
enum ApplicationStatus {
  pending, // Enviada, aguardando resposta
  accepted, // Aceita pela barbearia
  rejected, // Rejeitada pela barbearia
  withdrawn, // Retirada pelo barbeiro
}
