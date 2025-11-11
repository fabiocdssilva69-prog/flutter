import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../ai_assistant/services/gemini_service.dart';

part 'bi_dashboard_controller.g.dart';

class BusinessInsight {
  final String title;
  final String description;
  final String type; // positive, negative, neutral, warning
  final double? impact; // 0-1
  final List<String> recommendations;

  BusinessInsight({
    required this.title,
    required this.description,
    required this.type,
    this.impact,
    required this.recommendations,
  });
}

class BIMetrics {
  final double totalRevenue;
  final double averageTicket;
  final int totalBookings;
  final int totalClients;
  final double growthRate;
  final double retentionRate;
  final double cancelationRate;
  final Map<String, double> revenueByService;
  final Map<String, int> bookingsByHour;
  final List<BusinessInsight> insights;

  BIMetrics({
    required this.totalRevenue,
    required this.averageTicket,
    required this.totalBookings,
    required this.totalClients,
    required this.growthRate,
    required this.retentionRate,
    required this.cancelationRate,
    required this.revenueByService,
    required this.bookingsByHour,
    required this.insights,
  });
}

@riverpod
class BIDashboardController extends _$BIDashboardController {
  @override
  Future<BIMetrics> build(String barberId, DateTime startDate, DateTime endDate) async {
    return _generateMetrics(barberId, startDate, endDate);
  }

  Future<BIMetrics> _generateMetrics(String barberId, DateTime startDate, DateTime endDate) async {
    // Buscar dados do Firestore
    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    final bookings = bookingsSnapshot.docs.map((doc) => doc.data()).toList();

    // Calcular métricas básicas
    final totalRevenue = bookings.fold<double>(0, (sum, b) => sum + (b['price'] ?? 0).toDouble());
    final totalBookings = bookings.length;
    final uniqueClients = bookings.map((b) => b['clientId']).toSet().length;
    final avgTicket = totalBookings > 0 ? totalRevenue / totalBookings : 0.0;

    // Receita por serviço
    final revenueByService = <String, double>{};
    for (final booking in bookings) {
      final service = booking['serviceType'] ?? 'Outros';
      revenueByService[service] = (revenueByService[service] ?? 0) + (booking['price'] ?? 0).toDouble();
    }

    // Agendamentos por hora
    final bookingsByHour = <String, int>{};
    for (final booking in bookings) {
      final date = (booking['date'] as Timestamp).toDate();
      final hour = '${date.hour}:00';
      bookingsByHour[hour] = (bookingsByHour[hour] ?? 0) + 1;
    }

    // Taxa de cancelamento
    final canceled = bookings.where((b) => b['status'] == 'cancelled').length;
    final cancelationRate = totalBookings > 0 ? canceled / totalBookings : 0.0;

    // Calcular crescimento (comparar com período anterior)
    final previousStart = startDate.subtract(endDate.difference(startDate));
    final previousBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(previousStart))
        .where('date', isLessThan: Timestamp.fromDate(startDate))
        .get();

    final previousRevenue = previousBookings.docs.fold<double>(
      0,
      (sum, doc) => sum + (doc.data()['price'] ?? 0).toDouble(),
    );
    final growthRate = previousRevenue > 0 ? (totalRevenue - previousRevenue) / previousRevenue : 0.0;

    // Gerar insights com IA
    final insights = await _generateInsightsWithAI(
      totalRevenue: totalRevenue,
      avgTicket: avgTicket,
      totalBookings: totalBookings,
      uniqueClients: uniqueClients,
      growthRate: growthRate,
      cancelationRate: cancelationRate,
      revenueByService: revenueByService,
      bookingsByHour: bookingsByHour,
    );

    return BIMetrics(
      totalRevenue: totalRevenue,
      averageTicket: avgTicket,
      totalBookings: totalBookings,
      totalClients: uniqueClients,
      growthRate: growthRate,
      retentionRate: 0.75, // TODO: Calcular realmente
      cancelationRate: cancelationRate,
      revenueByService: revenueByService,
      bookingsByHour: bookingsByHour,
      insights: insights,
    );
  }

  Future<List<BusinessInsight>> _generateInsightsWithAI({
    required double totalRevenue,
    required double avgTicket,
    required int totalBookings,
    required int uniqueClients,
    required double growthRate,
    required double cancelationRate,
    required Map<String, double> revenueByService,
    required Map<String, int> bookingsByHour,
  }) async {
    final prompt =
        '''
Analise os dados de negócio de uma barbearia e gere insights acionáveis:

DADOS:
- Receita Total: R\$ ${totalRevenue.toStringAsFixed(2)}
- Ticket Médio: R\$ ${avgTicket.toStringAsFixed(2)}
- Total de Agendamentos: $totalBookings
- Clientes Únicos: $uniqueClients
- Taxa de Crescimento: ${(growthRate * 100).toStringAsFixed(1)}%
- Taxa de Cancelamento: ${(cancelationRate * 100).toStringAsFixed(1)}%
- Receita por Serviço: ${revenueByService.entries.map((e) => '${e.key}: R\$ ${e.value.toStringAsFixed(2)}').join(', ')}
- Horários Mais Movimentados: ${bookingsByHour.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value))
          ..take(3).map((e) => '${e.key} (${e.value} agend.)').join(', ')}

Forneça 3-5 insights no formato:
TÍTULO: (insight curto e direto)
DESCRIÇÃO: (análise detalhada)
TIPO: (positive/negative/neutral/warning)
IMPACTO: (0.0 a 1.0)
RECOMENDAÇÕES:
- Ação 1
- Ação 2
---
''';

    try {
      final gemini = GeminiService();
      final response = await gemini.sendMessage(message: prompt);
      return _parseInsights(response);
    } catch (e) {
      // Fallback: insights básicos
      return _generateBasicInsights(growthRate, cancelationRate, revenueByService);
    }
  }

  List<BusinessInsight> _parseInsights(String aiResponse) {
    final insights = <BusinessInsight>[];
    final blocks = aiResponse.split('---');

    for (final block in blocks) {
      if (block.trim().isEmpty) continue;

      final titleMatch = RegExp(r'TÍTULO:\s*(.+)', multiLine: true).firstMatch(block);
      final descMatch = RegExp(r'DESCRIÇÃO:\s*(.+)', multiLine: true).firstMatch(block);
      final typeMatch = RegExp(r'TIPO:\s*(\w+)', multiLine: true).firstMatch(block);
      final impactMatch = RegExp(r'IMPACTO:\s*([\d.]+)', multiLine: true).firstMatch(block);
      final recsMatch = RegExp(r'RECOMENDAÇÕES:\s*((?:-.+\n?)+)', multiLine: true).firstMatch(block);

      if (titleMatch != null && descMatch != null && typeMatch != null) {
        final recommendations = <String>[];
        if (recsMatch != null) {
          recommendations.addAll(
            recsMatch
                .group(1)!
                .split('\n')
                .where((line) => line.trim().startsWith('-'))
                .map((line) => line.replaceFirst('-', '').trim()),
          );
        }

        insights.add(
          BusinessInsight(
            title: titleMatch.group(1)!.trim(),
            description: descMatch.group(1)!.trim(),
            type: typeMatch.group(1)!.toLowerCase(),
            impact: double.tryParse(impactMatch?.group(1) ?? '0.5'),
            recommendations: recommendations,
          ),
        );
      }
    }

    return insights;
  }

  List<BusinessInsight> _generateBasicInsights(
    double growthRate,
    double cancelationRate,
    Map<String, double> revenueByService,
  ) {
    final insights = <BusinessInsight>[];

    // Insight de crescimento
    if (growthRate > 0.1) {
      insights.add(
        BusinessInsight(
          title: '📈 Crescimento Positivo',
          description: 'Sua receita cresceu ${(growthRate * 100).toStringAsFixed(0)}% em relação ao período anterior',
          type: 'positive',
          impact: growthRate.clamp(0, 1),
          recommendations: ['Continue investindo nas estratégias atuais', 'Considere expandir sua equipe'],
        ),
      );
    } else if (growthRate < -0.1) {
      insights.add(
        BusinessInsight(
          title: '⚠️ Queda na Receita',
          description: 'Receita caiu ${(growthRate.abs() * 100).toStringAsFixed(0)}%',
          type: 'negative',
          impact: growthRate.abs().clamp(0, 1),
          recommendations: [
            'Revise sua precificação',
            'Aumente divulgação nas redes sociais',
            'Crie promoções atrativas',
          ],
        ),
      );
    }

    // Insight de cancelamento
    if (cancelationRate > 0.2) {
      insights.add(
        BusinessInsight(
          title: '🚨 Alta Taxa de Cancelamento',
          description: '${(cancelationRate * 100).toStringAsFixed(0)}% dos agendamentos são cancelados',
          type: 'warning',
          impact: cancelationRate.clamp(0, 1),
          recommendations: [
            'Implemente política de confirmação 24h antes',
            'Envie lembretes automáticos',
            'Considere cobrar taxa de no-show',
          ],
        ),
      );
    }

    // Insight de serviço mais lucrativo
    if (revenueByService.isNotEmpty) {
      final topService = revenueByService.entries.reduce((a, b) => a.value > b.value ? a : b);
      insights.add(
        BusinessInsight(
          title: '💰 Serviço Mais Lucrativo',
          description: '${topService.key} gerou R\$ ${topService.value.toStringAsFixed(2)}',
          type: 'positive',
          impact: 0.7,
          recommendations: [
            'Promova mais este serviço',
            'Treine equipe para oferecer upgrades',
            'Crie combos com outros serviços',
          ],
        ),
      );
    }

    return insights;
  }
}
