import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../services/gemini_service.dart';

part 'smart_notifications_controller.g.dart';

class NotificationSchedule {
  final String type; // reminder, promotion, tip
  final String message;
  final DateTime scheduledTime;
  final double confidence;

  NotificationSchedule({
    required this.type,
    required this.message,
    required this.scheduledTime,
    required this.confidence,
  });
}

@riverpod
class SmartNotificationsController extends _$SmartNotificationsController {
  @override
  Future<List<NotificationSchedule>> build() async {
    return [];
  }

  Future<List<NotificationSchedule>> generateSmartSchedule(String userId) async {
    // Analyze user behavior
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(20)
        .get();

    if (bookingsSnapshot.docs.isEmpty) {
      return [];
    }

    // Extract patterns
    final bookingTimes = bookingsSnapshot.docs.map((doc) {
      final date = (doc.data()['date'] as Timestamp).toDate();
      return '${date.weekday} - ${date.hour}:00';
    }).toList();

    final avgDaysBetween = _calculateAverageDaysBetween(bookingsSnapshot.docs);

    // Ask Gemini for optimal notification times
    final prompt =
        '''
Analyze este histórico de agendamentos e sugira 3 horários otimizados para enviar notificações:

Padrões identificados:
- Horários preferidos: ${bookingTimes.take(5).join(', ')}
- Média de dias entre cortes: $avgDaysBetween dias

Retorne 3 sugestões no formato:
TIPO: (reminder/promotion/tip)
MENSAGEM: (texto da notificação)
HORÁRIO: (DD/MM/YYYY HH:MM)
CONFIANÇA: (0.0 a 1.0)
---
''';

    try {
      final gemini = ref.read(geminiServiceProvider);
      final response = await gemini.generateText(prompt);
      return _parseSchedule(response);
    } catch (e) {
      // Fallback: simple heuristic
      final lastBooking = (bookingsSnapshot.docs.first.data()['date'] as Timestamp).toDate();
      final nextSuggestedDate = lastBooking.add(Duration(days: avgDaysBetween));

      return [
        NotificationSchedule(
          type: 'reminder',
          message: 'Hora de agendar seu próximo corte! 💇',
          scheduledTime: nextSuggestedDate.subtract(const Duration(days: 2)),
          confidence: 0.75,
        ),
      ];
    }
  }

  int _calculateAverageDaysBetween(List<QueryDocumentSnapshot> docs) {
    if (docs.length < 2) return 30;

    final dates = docs.map((doc) => (doc.data() as Map)['date'] as Timestamp).toList();
    int totalDays = 0;

    for (int i = 0; i < dates.length - 1; i++) {
      final diff = dates[i].toDate().difference(dates[i + 1].toDate()).inDays;
      totalDays += diff;
    }

    return (totalDays / (dates.length - 1)).round();
  }

  List<NotificationSchedule> _parseSchedule(String aiResponse) {
    final schedules = <NotificationSchedule>[];
    final blocks = aiResponse.split('---');

    for (final block in blocks) {
      if (block.trim().isEmpty) continue;

      final typeMatch = RegExp(r'TIPO:\s*(\w+)').firstMatch(block);
      final messageMatch = RegExp(r'MENSAGEM:\s*(.+)').firstMatch(block);
      final timeMatch = RegExp(r'HORÁRIO:\s*(\d+/\d+/\d+\s+\d+:\d+)').firstMatch(block);
      final confidenceMatch = RegExp(r'CONFIANÇA:\s*([\d.]+)').firstMatch(block);

      if (typeMatch != null && messageMatch != null && timeMatch != null) {
        schedules.add(
          NotificationSchedule(
            type: typeMatch.group(1)!,
            message: messageMatch.group(1)!.trim(),
            scheduledTime: _parseDateTime(timeMatch.group(1)!),
            confidence: double.tryParse(confidenceMatch?.group(1) ?? '0.5') ?? 0.5,
          ),
        );
      }
    }

    return schedules;
  }

  DateTime _parseDateTime(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');

      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (e) {
      return DateTime.now().add(const Duration(days: 7));
    }
  }
}
