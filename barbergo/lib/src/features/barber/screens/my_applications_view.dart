import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/application_entity.dart';
import '../../core/core_data_controller.dart';
import '../controllers/barber_controller.dart';

class MyApplicationsView extends ConsumerWidget {
  const MyApplicationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(myApplicationsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Candidaturas')),
      body: applicationsAsync.when(
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhuma candidatura ainda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Deslize para a direita nas vagas para se candidatar', textAlign: TextAlign.center),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              final barbershopAsync = ref.watch(userDetailsProvider(application.barbershopId));

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome da barbearia
                      barbershopAsync.when(
                        data: (barbershop) {
                          // TODO: Buscar ProfileEntity para obter o nome completo
                          final displayName = barbershop?.email.split('@').first ?? 'Barbearia';
                          return Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
                        },
                        loading: () => const Text('Carregando...'),
                        error: (_, __) => const Text('Erro ao carregar'),
                      ),

                      const SizedBox(height: 8),

                      // Data da candidatura
                      Text(
                        'Candidatura enviada em ${_formatDate(application.createdAt)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),

                      const SizedBox(height: 12),

                      // Status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(application.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(application.status),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [const Icon(Icons.error_outline, size: 48), const SizedBox(height: 16), Text('Erro: $error')],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.accepted:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.withdrawn:
        return Colors.grey;
    }
  }

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pendente';
      case ApplicationStatus.accepted:
        return 'Aceita';
      case ApplicationStatus.rejected:
        return 'Rejeitada';
      case ApplicationStatus.withdrawn:
        return 'Retirada';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
