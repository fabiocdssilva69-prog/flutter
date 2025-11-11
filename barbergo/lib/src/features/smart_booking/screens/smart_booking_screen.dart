import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/smart_booking_controller.dart';

class SmartBookingScreen extends ConsumerStatefulWidget {
  final String barberId;
  final String barberName;

  const SmartBookingScreen({super.key, required this.barberId, required this.barberName});

  @override
  ConsumerState<SmartBookingScreen> createState() => _SmartBookingScreenState();
}

class _SmartBookingScreenState extends ConsumerState<SmartBookingScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    setState(() => _loading = true);
    await ref
        .read(smartBookingControllerProvider.notifier)
        .generateSmartSuggestions(
          userId: 'current-user-id', // TODO: ID real
          barberId: widget.barberId,
        );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = ref.watch(smartBookingControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Agendamento Inteligente'), subtitle: Text(widget.barberName)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : suggestions.when(
              data: (list) => list.isEmpty
                  ? const Center(child: Text('Nenhuma sugestão disponível'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          '🤖 Sugestões Inteligentes',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Baseado no seu histórico e disponibilidade do barbeiro',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ...list.map(
                          (suggestion) =>
                              _SuggestionCard(suggestion: suggestion, onBook: () => _confirmBooking(suggestion)),
                        ),
                      ],
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Erro: $e')),
            ),
    );
  }

  Future<void> _confirmBooking(BookingSuggestion suggestion) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Agendamento'),
        content: Text('Deseja agendar para ${DateFormat('dd/MM/yyyy HH:mm').format(suggestion.suggestedTime)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmar')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(smartBookingControllerProvider.notifier)
          .confirmBooking(
            suggestion,
            'current-user-id', // TODO: ID real
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agendamento confirmado!')));
        Navigator.pop(context);
      }
    }
  }
}

class _SuggestionCard extends StatelessWidget {
  final BookingSuggestion suggestion;
  final VoidCallback onBook;

  const _SuggestionCard({required this.suggestion, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(suggestion.suggestedTime),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  DateFormat('HH:mm').format(suggestion.suggestedTime),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(suggestion.reason, style: const TextStyle(fontSize: 14))),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: suggestion.confidence,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      suggestion.confidence > 0.8
                          ? Colors.green
                          : suggestion.confidence > 0.6
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${(suggestion.confidence * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onBook,
                icon: const Icon(Icons.check),
                label: const Text('Agendar este horário'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
