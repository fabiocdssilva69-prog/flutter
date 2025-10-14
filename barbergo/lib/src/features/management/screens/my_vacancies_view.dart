import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/vacancy_controller.dart';
import '../../../core/theme/app_colors.dart';

class MyVacanciesView extends ConsumerWidget {
  const MyVacanciesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vacanciesAsync = ref.watch(myVacanciesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Vagas')),
      body: vacanciesAsync.when(
        data: (vacancies) {
          if (vacancies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.work_outline, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma vaga criada ainda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Clique no botão abaixo para criar sua primeira vaga',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vacancies.length,
            itemBuilder: (context, index) {
              final vacancy = vacancies[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    vacancy.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(vacancy.workHours),
                  trailing: Icon(
                    vacancy.isActive ? Icons.check_circle : Icons.pause_circle,
                    color: vacancy.isActive ? Colors.green : Colors.orange,
                  ),
                  onTap: () =>
                      context.push('/vacancy-details/${vacancy.vacancyId}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Erro ao carregar vagas: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-vacancy'),
        icon: const Icon(Icons.add),
        label: const Text('Nova Vaga'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
