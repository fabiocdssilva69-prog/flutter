import 'package:dart_mappable/dart_mappable.dart';

import '../../core/infrastructure/mappable_hooks.dart';

part 'booking_entity.mapper.dart';

/// Status do agendamento
enum BookingStatus {
  pending, // Aguardando confirmação
  confirmed, // Confirmado
  cancelled, // Cancelado
  completed, // Concluído
}

/// Entidade que representa um agendamento
@MappableClass()
class BookingEntity with BookingEntityMappable {
  /// ID único do agendamento
  final String id;

  /// ID do barbeiro
  final String barberId;

  /// Nome do barbeiro (desnormalizado para performance)
  final String barberName;

  /// URL do avatar do barbeiro (desnormalizado)
  final String? barberAvatarUrl;

  /// ID do cliente
  final String clientId;

  /// Nome do cliente (desnormalizado)
  final String clientName;

  /// URL do avatar do cliente (desnormalizado)
  final String? clientAvatarUrl;

  /// Tipo de serviço (ex: 'Corte', 'Corte + Barba', etc.)
  final String serviceType;

  /// Data e hora do agendamento
  @MappableField(hook: TimestampHook())
  final DateTime dateTime;

  /// Duração em minutos (padrão: 60)
  final int durationMinutes;

  /// Preço do serviço
  final double price;

  /// Status do agendamento
  final BookingStatus status;

  /// Notas/observações do cliente
  final String? notes;

  /// Data de criação
  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  /// Data de atualização
  @MappableField(hook: TimestampHook())
  final DateTime? updatedAt;

  /// Motivo do cancelamento (se status == cancelled)
  final String? cancellationReason;

  /// Quem cancelou (barberId ou clientId)
  final String? cancelledBy;

  const BookingEntity({
    required this.id,
    required this.barberId,
    required this.barberName,
    this.barberAvatarUrl,
    required this.clientId,
    required this.clientName,
    this.clientAvatarUrl,
    required this.serviceType,
    required this.dateTime,
    this.durationMinutes = 60,
    required this.price,
    this.status = BookingStatus.pending,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.cancellationReason,
    this.cancelledBy,
  });

  /// Helper: Verifica se o agendamento pode ser cancelado
  bool get canBeCancelled {
    if (status == BookingStatus.cancelled || status == BookingStatus.completed) {
      return false;
    }
    // Só pode cancelar até 2 horas antes
    final now = DateTime.now();
    final hoursUntilBooking = dateTime.difference(now).inHours;
    return hoursUntilBooking >= 2;
  }

  /// Helper: Verifica se o agendamento está no passado
  bool get isPast {
    return dateTime.isBefore(DateTime.now());
  }

  /// Helper: Verifica se o agendamento é hoje
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day;
  }

  /// Helper: Hora de término do agendamento
  DateTime get endTime {
    return dateTime.add(Duration(minutes: durationMinutes));
  }

  /// Método estático para deserialização
  static const fromMap = BookingEntityMapper.fromMap;
}
