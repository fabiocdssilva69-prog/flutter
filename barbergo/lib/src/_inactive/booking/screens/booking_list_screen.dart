import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/booking_entity.dart';
import '../controllers/booking_controller.dart';

/// Tela que lista os agendamentos do usuário
class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  /// Formata data e hora para exibição
  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    return '${dateFormat.format(dateTime)} às ${timeFormat.format(dateTime)}';
  }

  /// Retorna cor baseada no status
  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  /// Retorna texto do status em português
  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Aguardando';
      case BookingStatus.confirmed:
        return 'Confirmado';
      case BookingStatus.cancelled:
        return 'Cancelado';
      case BookingStatus.completed:
        return 'Concluído';
    }
  }

  /// Mostra dialog de cancelamento
  Future<void> _showCancelDialog(BuildContext context, WidgetRef ref, BookingEntity booking) async {
    if (!booking.canBeCancelled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este agendamento não pode ser cancelado'), backgroundColor: Colors.red),
      );
      return;
    }

    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tem certeza que deseja cancelar este agendamento?', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Motivo do cancelamento',
                border: OutlineInputBorder(),
                hintText: 'Ex: Imprevisto, conflito de horários...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Voltar')),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancelar Agendamento'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final reason = reasonController.text.isEmpty ? 'Cancelado pelo cliente' : reasonController.text;

      try {
        await ref.read(bookingControllerProvider.notifier).cancelBooking(booking.id, reason);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Agendamento cancelado com sucesso'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao cancelar: $e'), backgroundColor: Colors.red));
        }
      }
    }

    reasonController.dispose();
  }

  /// Constrói card de agendamento
  Widget _buildBookingCard(BuildContext context, WidgetRef ref, BookingEntity booking) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Navegar para detalhes do agendamento
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com foto e nome do barbeiro
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: booking.barberAvatarUrl != null ? NetworkImage(booking.barberAvatarUrl!) : null,
                    child: booking.barberAvatarUrl == null ? const Icon(Icons.person) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.barberName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(booking.serviceType, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                  // Badge de status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(booking.status),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Data, hora e preço
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(_formatDateTime(booking.dateTime), style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  Text(
                    'R\$ ${booking.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),

              // Duração
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text('${booking.durationMinutes} minutos', style: const TextStyle(fontSize: 14)),
                ],
              ),

              // Observações (se houver)
              if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.note, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(booking.notes!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      ),
                    ],
                  ),
                ),
              ],

              // Motivo de cancelamento (se cancelado)
              if (booking.status == BookingStatus.cancelled && booking.cancellationReason != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.cancel, size: 16, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Motivo: ${booking.cancellationReason}',
                          style: const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Botão de cancelar (apenas se permitido)
              if (booking.canBeCancelled) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showCancelDialog(context, ref, booking),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Cancelar Agendamento'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Agendamentos'), elevation: 0),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Nenhum agendamento', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text(
                    'Seus agendamentos aparecerão aqui',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          // Separar agendamentos futuros e passados
          final now = DateTime.now();
          final upcomingBookings = bookings
              .where((b) => b.dateTime.isAfter(now) && b.status != BookingStatus.cancelled)
              .toList();
          final pastBookings = bookings
              .where((b) => b.dateTime.isBefore(now) || b.status == BookingStatus.cancelled)
              .toList();

          return ListView(
            children: [
              if (upcomingBookings.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Próximos Agendamentos',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ...upcomingBookings.map((booking) => _buildBookingCard(context, ref, booking)),
              ],
              if (pastBookings.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Histórico',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ...pastBookings.map((booking) => _buildBookingCard(context, ref, booking)),
              ],
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro ao carregar agendamentos:\n$error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userBookingsProvider),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
