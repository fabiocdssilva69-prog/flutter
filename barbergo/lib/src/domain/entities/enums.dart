// Tipos de Conta
enum AccountType { barber, barbershop }

// Tipos de Vaga
enum VacancyType {
  freelancer, // Autônomo
  clt, // Carteira Assinada (Fixo)
  commission, // Comissionado
}

// Status da Candidatura
enum ApplicationStatus {
  pending, // Enviada, aguardando resposta
  accepted, // Aceita pela barbearia
  rejected, // Rejeitada pela barbearia
  withdrawn, // Retirada pelo candidato
}

// Planos de assinatura
enum SubscriptionTier { free, premium }
