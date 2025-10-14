import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/application_entity.dart';
import '../../../domain/entities/enums.dart';
import '../../core/core_data_controller.dart';
import '../controllers/vacancy_controller.dart';
import '../../../core/theme/app_colors.dart';

class ApplicationTile extends ConsumerWidget {
  const ApplicationTile({super.key, required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barberAsync = ref.watch(userDetailsProvider(application.barberId));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do barbeiro
            barberAsync.when(
              data: (barber) {
                if (barber == null)
                  return const Text('Barbeiro não encontrado');

                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        barber.name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barber.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            barber.email,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Erro ao carregar dados'),
            ),

            const SizedBox(height: 12),

            // Data da candidatura
            Text(
              'Candidatou-se em ${_formatDate(application.createdAt)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            const SizedBox(height: 16),

            // Status e ações
            _buildStatusSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, WidgetRef ref) {
    switch (application.status) {
      case ApplicationStatus.pending:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleReject(ref),
                icon: const Icon(Icons.close),
                label: const Text('Rejeitar'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _handleAccept(ref),
                icon: const Icon(Icons.check),
                label: const Text('Aceitar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        );

      case ApplicationStatus.accepted:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Candidatura aceita',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );

      case ApplicationStatus.rejected:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Candidatura rejeitada',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );

      case ApplicationStatus.withdrawn:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Candidatura retirada',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    }
  }

  void _handleAccept(WidgetRef ref) async {
    await ref
        .read(managementControllerProvider.notifier)
        .updateApplicationStatus(
          application.applicationId,
          ApplicationStatus.accepted,
        );
  }

  void _handleReject(WidgetRef ref) async {
    await ref
        .read(managementControllerProvider.notifier)
        .updateApplicationStatus(
          application.applicationId,
          ApplicationStatus.rejected,
        );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
