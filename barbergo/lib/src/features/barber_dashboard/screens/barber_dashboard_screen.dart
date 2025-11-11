import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/barber_dashboard_controller.dart';

class BarberDashboardScreen extends ConsumerWidget {
  const BarberDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(barberDashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard do Barbeiro')),
      body: stats.when(
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(barberDashboardControllerProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Hoje',
                      value: 'R\$ ${data.todayRevenue.toStringAsFixed(2)}',
                      icon: Icons.today,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Semana',
                      value: 'R\$ ${data.weekRevenue.toStringAsFixed(2)}',
                      icon: Icons.date_range,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Mês',
                      value: 'R\$ ${data.monthRevenue.toStringAsFixed(2)}',
                      icon: Icons.calendar_month,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Agendamentos',
                      value: '${data.todayBookings}',
                      icon: Icons.event,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Avaliações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 40),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.averageRating.toStringAsFixed(1)}',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text('${data.totalReviews} avaliações', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Receita dos Últimos 7 Dias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(height: 200, child: _RevenueChart(data: data.revenueChart)),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  final List<RevenueByDay> data;

  const _RevenueChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxRevenue = data.isEmpty ? 100.0 : data.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((day) {
        final height = maxRevenue == 0 ? 0.0 : (day.amount / maxRevenue) * 150;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('R\$ ${day.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10)),
            const SizedBox(height: 4),
            Container(
              width: 30,
              height: height,
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: 4),
            Text(day.day, style: const TextStyle(fontSize: 10)),
          ],
        );
      }).toList(),
    );
  }
}
