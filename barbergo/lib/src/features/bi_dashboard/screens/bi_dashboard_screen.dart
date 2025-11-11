import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/bi_dashboard_controller.dart';

class BIDashboardScreen extends ConsumerStatefulWidget {
  final String barberId;

  const BIDashboardScreen({super.key, required this.barberId});

  @override
  ConsumerState<BIDashboardScreen> createState() => _BIDashboardScreenState();
}

class _BIDashboardScreenState extends ConsumerState<BIDashboardScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(bIDashboardControllerProvider(widget.barberId, _startDate, _endDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Intelligence'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _selectDateRange),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(bIDashboardControllerProvider(widget.barberId, _startDate, _endDate)),
          ),
        ],
      ),
      body: metrics.when(
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(bIDashboardControllerProvider(widget.barberId, _startDate, _endDate).future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildKPICards(data),
              const SizedBox(height: 24),
              _buildInsightsSection(data.insights),
              const SizedBox(height: 24),
              _buildRevenueChart(data),
              const SizedBox(height: 24),
              _buildHourlyChart(data),
              const SizedBox(height: 24),
              _buildServicePieChart(data),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  Widget _buildKPICards(BIMetrics metrics) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _KPICard(
                title: 'Receita Total',
                value: 'R\$ ${metrics.totalRevenue.toStringAsFixed(2)}',
                icon: Icons.attach_money,
                color: Colors.green,
                trend: metrics.growthRate,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KPICard(
                title: 'Ticket Médio',
                value: 'R\$ ${metrics.averageTicket.toStringAsFixed(2)}',
                icon: Icons.receipt,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _KPICard(
                title: 'Agendamentos',
                value: metrics.totalBookings.toString(),
                icon: Icons.event,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KPICard(
                title: 'Clientes',
                value: metrics.totalClients.toString(),
                icon: Icons.people,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _KPICard(
                title: 'Taxa Retenção',
                value: '${(metrics.retentionRate * 100).toStringAsFixed(0)}%',
                icon: Icons.favorite,
                color: Colors.pink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KPICard(
                title: 'Cancelamentos',
                value: '${(metrics.cancelationRate * 100).toStringAsFixed(0)}%',
                icon: Icons.cancel,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightsSection(List<BusinessInsight> insights) {
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb, color: Colors.amber),
            const SizedBox(width: 8),
            const Text('Insights da IA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...insights.map((insight) => _InsightCard(insight: insight)),
      ],
    );
  }

  Widget _buildRevenueChart(BIMetrics metrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Crescimento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 4),
                        const FlSpot(2, 3.5),
                        const FlSpot(3, 5),
                        const FlSpot(4, 4.5),
                        const FlSpot(5, 6),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyChart(BIMetrics metrics) {
    final sortedHours = metrics.bookingsByHour.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agendamentos por Horário', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: sortedHours.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          color: Colors.blue,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < sortedHours.length) {
                            return Text(sortedHours[value.toInt()].key, style: const TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicePieChart(BIMetrics metrics) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    final services = metrics.revenueByService.entries.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Receita por Serviço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: services.asMap().entries.map((entry) {
                          return PieChartSectionData(
                            value: entry.value.value,
                            title: 'R\$ ${entry.value.value.toStringAsFixed(0)}',
                            color: colors[entry.key % colors.length],
                            radius: 50,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: services.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(width: 12, height: 12, color: colors[entry.key % colors.length]),
                            const SizedBox(width: 8),
                            Text(entry.value.key),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double? trend;

  const _KPICard({required this.title, required this.value, required this.icon, required this.color, this.trend});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                if (trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: trend! >= 0 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(trend! >= 0 ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: Colors.white),
                        Text(
                          '${(trend!.abs() * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final BusinessInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;

    switch (insight.type) {
      case 'positive':
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      case 'negative':
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        break;
      case 'warning':
        borderColor = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      default:
        borderColor = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.1);
    }

    return Card(
      color: bgColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: ExpansionTile(
        title: Text(
          insight.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: borderColor),
        ),
        subtitle: Text(insight.description),
        children: [
          if (insight.recommendations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recomendações:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...insight.recommendations.map(
                    (rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(child: Text(rec)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
