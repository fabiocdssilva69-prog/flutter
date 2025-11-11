import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../domain/entities/profile_entity.dart';
import '../controllers/booking_controller.dart';
import '../widgets/time_slot_picker.dart';

/// Tela de agendamento
class BookingScreen extends ConsumerStatefulWidget {
  final ProfileEntity barberProfile;

  const BookingScreen({super.key, required this.barberProfile});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  String? _selectedService;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Confirma o agendamento
  Future<void> _confirmBooking() async {
    if (_selectedTime == null || _selectedService == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione um horário e serviço'), backgroundColor: Colors.red));
      return;
    }

    // Parse do horário selecionado
    final timeParts = _selectedTime!.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final dateTime = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, hour, minute);

    // Preço baseado no serviço (pode ser melhorado com preços por serviço)
    final price = widget.barberProfile.hourlyRate ?? 80.0;

    try {
      await ref
          .read(bookingControllerProvider.notifier)
          .createBooking(
            barberId: widget.barberProfile.userId,
            barberName: widget.barberProfile.name,
            barberAvatarUrl: widget.barberProfile.avatarUrl,
            serviceType: _selectedService!,
            dateTime: dateTime,
            price: price,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Agendamento criado com sucesso!'), backgroundColor: Colors.green));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao criar agendamento: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(bookingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar Horário'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com foto e nome do barbeiro
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: widget.barberProfile.avatarUrl != null
                        ? NetworkImage(widget.barberProfile.avatarUrl!)
                        : null,
                    child: widget.barberProfile.avatarUrl == null ? const Icon(Icons.person, size: 30) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.barberProfile.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.barberProfile.location,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        ),
                        if (widget.barberProfile.rating > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.barberProfile.rating.toStringAsFixed(1)} '
                                '(${widget.barberProfile.reviewCount} avaliações)',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Seleção de serviço
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selecione o Serviço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.barberProfile.services.map((service) {
                      final isSelected = service == _selectedService;
                      return FilterChip(
                        label: Text(service),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedService = selected ? service : null;
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        checkmarkColor: Theme.of(context).primaryColor,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Calendário
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selecione a Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 90)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedTime = null; // Reset time selection
                      });
                    },
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Horários disponíveis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Horários Disponíveis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  FutureBuilder(
                    future: ref
                        .read(bookingControllerProvider.notifier)
                        .getBarberBookingsByDate(widget.barberProfile.userId, _selectedDay),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()),
                        );
                      }

                      final existingBookings = snapshot.data ?? [];

                      return TimeSlotPicker(
                        selectedDate: _selectedDay,
                        selectedTime: _selectedTime,
                        existingBookings: existingBookings,
                        workingHours: widget.barberProfile.workingHours,
                        onTimeSelected: (time) {
                          setState(() {
                            _selectedTime = time;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(),

            // Observações
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Observações (opcional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    maxLength: 200,
                    decoration: InputDecoration(
                      hintText: 'Ex: Prefiro corte mais curto nas laterais',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            // Botão de confirmar
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : _confirmBooking,
                  child: controller.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Confirmar Agendamento',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
