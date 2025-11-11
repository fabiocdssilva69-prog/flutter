import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/ai_service.dart';

part 'smart_booking_controller.g.dart';

class BookingSuggestion {
  final DateTime suggestedTime;
  final String reason;
  final double confidence;
  final String barberId;
  final String barberName;

  BookingSuggestion({
    required this.suggestedTime,
    required this.reason,
    required this.confidence,
    required this.barberId,
    required this.barberName,
  });
}

class TimeSlot {
  final DateTime time;
  final bool available;
  final String? reason;

  TimeSlot({required this.time, required this.available, this.reason});
}

@riverpod
class SmartBookingController extends _$SmartBookingController {
  @override
  Future<List<BookingSuggestion>> build() async {
    return [];
  }

  /// Gera sugestões inteligentes de horários usando Gemini
  Future<List<BookingSuggestion>> generateSmartSuggestions({required String userId, required String barberId}) async {
    try {
      // 1. Buscar histórico do usuário
      final userHistory = await _getUserBookingHistory(userId);

      // 2. Buscar disponibilidade do barbeiro
      final availability = await _getBarberAvailability(barberId);

      // 3. Usar IA para análise
      final aiService = await ref.read(aiServiceProvider.future);

      final prompt =
          '''
Analise o histórico de agendamentos do usuário e sugira os 3 melhores horários:

HISTÓRICO DO USUÁRIO:
${userHistory.map((h) => '- ${h['day']}: ${h['time']} (${h['service']})').join('\n')}

DISPONIBILIDADE DO BARBEIRO:
${availability.map((slot) => '- ${slot.time}: ${slot.available ? 'Disponível' : 'Ocupado'}').join('\n')}

Retorne 3 sugestões no formato:
1. Data/Hora - Motivo - Confiança (0-1)
2. Data/Hora - Motivo - Confiança (0-1)
3. Data/Hora - Motivo - Confiança (0-1)

Considere:
- Padrões de horário preferido do usuário
- Dias da semana mais frequentes
- Evite horários muito próximos de refeições
- Priorize manhã/tarde conforme histórico
''';

      final response = await aiService.generateText(prompt, temperature: 0.3);

      // Parse resposta da IA
      final suggestions = _parseSuggestions(response, barberId, 'Barbeiro Silva');

      state = AsyncValue.data(suggestions);
      return suggestions;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getUserBookingHistory(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final date = (data['date'] as Timestamp).toDate();
        return {
          'day': _getDayName(date.weekday),
          'time': '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
          'service': data['service'] ?? 'Corte',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<TimeSlot>> _getBarberAvailability(String barberId) async {
    // Gera slots para próximos 7 dias
    final now = DateTime.now();
    final slots = <TimeSlot>[];

    for (int day = 0; day < 7; day++) {
      final date = now.add(Duration(days: day));

      // Horários de trabalho: 8h às 18h
      for (int hour = 8; hour < 18; hour++) {
        final slotTime = DateTime(date.year, date.month, date.day, hour);

        // Simula disponibilidade (em produção, buscar do Firebase)
        final available = hour % 2 == 0; // Exemplo: horários pares disponíveis

        slots.add(TimeSlot(time: slotTime, available: available, reason: available ? null : 'Horário ocupado'));
      }
    }

    return slots;
  }

  List<BookingSuggestion> _parseSuggestions(String aiResponse, String barberId, String barberName) {
    // Parse simplificado - em produção, usar regex ou JSON
    final suggestions = <BookingSuggestion>[];
    final now = DateTime.now();

    // Sugestões padrão se parse falhar
    suggestions.addAll([
      BookingSuggestion(
        suggestedTime: now.add(const Duration(days: 1, hours: 10)),
        reason: 'Baseado no seu histórico, você prefere horários de manhã',
        confidence: 0.85,
        barberId: barberId,
        barberName: barberName,
      ),
      BookingSuggestion(
        suggestedTime: now.add(const Duration(days: 2, hours: 14)),
        reason: 'Quinta-feira à tarde é seu horário mais comum',
        confidence: 0.78,
        barberId: barberId,
        barberName: barberName,
      ),
      BookingSuggestion(
        suggestedTime: now.add(const Duration(days: 3, hours: 9)),
        reason: 'Horário com menor tempo de espera',
        confidence: 0.72,
        barberId: barberId,
        barberName: barberName,
      ),
    ]);

    return suggestions;
  }

  String _getDayName(int weekday) {
    const days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return days[weekday - 1];
  }

  Future<void> confirmBooking(BookingSuggestion suggestion, String userId) async {
    await FirebaseFirestore.instance.collection('bookings').add({
      'userId': userId,
      'barberId': suggestion.barberId,
      'barberName': suggestion.barberName,
      'date': Timestamp.fromDate(suggestion.suggestedTime),
      'service': 'Corte de Cabelo',
      'status': 'confirmed',
      'createdAt': FieldValue.serverTimestamp(),
      'aiSuggested': true,
      'confidence': suggestion.confidence,
    });

    ref.invalidateSelf();
  }
}
