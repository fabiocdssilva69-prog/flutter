import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/application_entity.dart';
import '../../../domain/entities/enums.dart';
import '../../core/core_data_controller.dart';
import '../controllers/management_controller.dart';

class ApplicationTile extends ConsumerWidget {
  const ApplicationTile({super.key, required this.application});

  final ApplicationEntity application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Busca os detalhes reais do barbeiro usando o CoreDataController
    final barberDetailsAsync = ref.watch(userDetailsProvider(application.barberId));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: barberDetailsAsync.when(
          data: (barber) {
            // Tratamento de erro robusto: Se o perfil não puder ser carregado.
            if (barber == null) {
              return ListTile(
                leading: const Icon(Icons.error_outline, color: Colors.red),
                title: const Text("Perfil não encontrado"),
                subtitle: Text("ID: ${application.barberId}. Pode ter sido excluído."),
              );
            }

            // Visualização normal se o perfil existir
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Text(barber.name.substring(0, 1))),
                  title: Text(barber.name, style: Theme.of(context).textTheme.titleLarge),
                  // Mostra Email e Telefone (com fallback)
                  subtitle: Text(
                    "Email: ${barber.email}\nTel: ${barber.contactPhone.isEmpty ? 'Não informado' : barber.contactPhone}",
                  ),
                ),
                const Divider(height: 32),
                _buildStatusSection(context, ref),
              ],
            );
          },
          loading: () => const Center(child: LinearProgressIndicator()),
          error: (e, s) => ListTile(
            leading: const Icon(Icons.error_outline, color: Colors.red),
            title: const Text("Erro ao carregar perfil"),
            subtitle: Text(e.toString()),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, WidgetRef ref) {
    final controller = ref.read(managementControllerProvider.notifier);

    switch (application.status) {
      case ApplicationStatus.pending:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.close, color: Colors.red),
              label: const Text("Rejeitar"),
              onPressed: () {
                controller.updateApplicationStatus(
                  applicationId: application.applicationId,
                  newStatus: ApplicationStatus.rejected,
                  barberId: application.barberId,
                );
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              // Ícone e Texto atualizados para refletir o chat
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("Aceitar e Abrir Chat"),
              onPressed: () {
                controller.updateApplicationStatus(
                  applicationId: application.applicationId,
                  newStatus: ApplicationStatus.accepted,
                  barberId: application.barberId,
                );
              },
            ),
          ],
        );

      case ApplicationStatus.accepted:
        return const Align(
          alignment: Alignment.centerRight,
          child: Chip(
            // Texto atualizado
            label: Text("✅ Aceito (Chat Aberto)"),
            backgroundColor: Colors.green,
            labelStyle: TextStyle(color: Colors.white),
          ),
        );

      case ApplicationStatus.rejected:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1 * 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Candidatura rejeitada',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
    }
  }
}
