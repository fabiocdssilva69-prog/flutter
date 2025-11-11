import 'package:flutter/material.dart';

import '../../../domain/entities/booking_entity.dart';

/// Widget para selecionar horários disponíveis
class TimeSlotPicker extends StatelessWidget {
  final DateTime selectedDate;
  final String? selectedTime;
  final List<BookingEntity> existingBookings;
  final Map<String, String>? workingHours;
  final ValueChanged<String> onTimeSelected;

  const TimeSlotPicker({
    super.key,
    required this.selectedDate,
    this.selectedTime,
    required this.existingBookings,
    this.workingHours,
    required this.onTimeSelected,
  });

  /// Gera lista de horários disponíveis
  List<String> _generateTimeSlots() {
    final slots = <String>[];

    // Pegar horário de trabalho do dia da semana
    final weekday = _getWeekdayKey(selectedDate.weekday);
    final workingHour = workingHours?[weekday];

    if (workingHour == null || workingHour.isEmpty) {
      // Se não tem horário definido, não abre
      return slots;
    }

    // Parse do formato "08:00-18:00"
    final parts = workingHour.split('-');
    if (parts.length != 2) return slots;

    final startParts = parts[0].split(':');
    final endParts = parts[1].split(':');

    if (startParts.length != 2 || endParts.length != 2) return slots;

    final startHour = int.tryParse(startParts[0]);
    final startMinute = int.tryParse(startParts[1]);
    final endHour = int.tryParse(endParts[0]);
    final endMinute = int.tryParse(endParts[1]);

    if (startHour == null || startMinute == null || endHour == null || endMinute == null) {
      return slots;
    }

    // Gerar slots de 30 em 30 minutos
    var currentHour = startHour;
    var currentMinute = startMinute;

    while (currentHour < endHour || (currentHour == endHour && currentMinute < endMinute)) {
      final timeSlot =
          '${currentHour.toString().padLeft(2, '0')}:'
          '${currentMinute.toString().padLeft(2, '0')}';
      slots.add(timeSlot);

      // Avançar 30 minutos
      currentMinute += 30;
      if (currentMinute >= 60) {
        currentMinute = 0;
        currentHour += 1;
      }
    }

    return slots;
  }

  /// Converte número do dia da semana para chave do mapa
  String _getWeekdayKey(int weekday) {
    const days = {1: 'monday', 2: 'tuesday', 3: 'wednesday', 4: 'thursday', 5: 'friday', 6: 'saturday', 7: 'sunday'};
    return days[weekday] ?? 'monday';
  }

  /// Verifica se o horário está ocupado
  bool _isTimeSlotOccupied(String timeSlot) {
    final slotParts = timeSlot.split(':');
    final slotHour = int.parse(slotParts[0]);
    final slotMinute = int.parse(slotParts[1]);

    final slotDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, slotHour, slotMinute);

    // Verificar se algum agendamento existente conflita
    return existingBookings.any((booking) {
      if (booking.status == BookingStatus.cancelled) return false;

      final bookingStart = booking.dateTime;
      final bookingEnd = booking.endTime;

      // Verificar se o slot está dentro do período do agendamento
      return slotDateTime.isAfter(bookingStart.subtract(const Duration(minutes: 1))) &&
          slotDateTime.isBefore(bookingEnd);
    });
  }

  /// Verifica se o horário já passou
  bool _isTimeSlotPast(String timeSlot) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    // Se a data selecionada não é hoje, não está no passado
    if (!selectedDay.isAtSameMomentAs(today)) {
      return selectedDate.isBefore(today);
    }

    // Se é hoje, verificar horário
    final slotParts = timeSlot.split(':');
    final slotHour = int.parse(slotParts[0]);
    final slotMinute = int.parse(slotParts[1]);

    final slotDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, slotHour, slotMinute);

    return slotDateTime.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _generateTimeSlots();

    if (timeSlots.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Sem horários disponíveis para esta data', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.0,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = timeSlots[index];
        final isOccupied = _isTimeSlotOccupied(timeSlot);
        final isPast = _isTimeSlotPast(timeSlot);
        final isSelected = timeSlot == selectedTime;
        final isDisabled = isOccupied || isPast;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : () => onTimeSelected(timeSlot),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : isDisabled
                    ? Colors.grey.shade200
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : isDisabled
                      ? Colors.grey.shade300
                      : Colors.grey.shade400,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  timeSlot,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : isDisabled
                        ? Colors.grey.shade400
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
