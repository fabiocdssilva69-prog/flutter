import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/vacancy_controller.dart';
import '../widgets/application_tile.dart';
import '../../../core/utils/async_value_ui.dart';

class VacancyDetailsScreen extends ConsumerWidget {
  const VacancyDetailsScreen({super.key, required this.vacancyId});

  final String vacancyId;

  // Factory para criar a partir do GoRouter
  static VacancyDetailsScreen fromRoute(dynamic state) {
    final vacancyId = state.pathParameters['vid'] ?? '';
    return VacancyDetailsScreen(vacancyId: vacancyId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(
      applicationsForVacancyStreamProvider(vacancyId),
    );

    // Observa erros no ManagementController
    ref.listen<AsyncValue<void>>(
      managementControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final isLoading = ref.watch(
      managementControllerProvider.select((state) => state.isLoading),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Vaga'),
        actions: [
          // TODO: Adicionar botão para pausar/ativar vaga
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Menu de opções
            },
          ),
        ],
      ),
      body: applicationsAsync.when(
        data: (applications) {
          if (applications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma candidatura ainda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Compartilhe esta vaga para receber candidaturas',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return IgnorePointer(
            ignoring: isLoading,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              itemBuilder: (context, index) {
                return ApplicationTile(application: applications[index]);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('Erro: $error'),
            ],
          ),
        ),
      ),
    );
  }
}
