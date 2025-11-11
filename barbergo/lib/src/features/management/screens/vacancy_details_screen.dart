import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/vacancy_match_repository.dart';

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
    // CORRIGIDO: Busca matches ao invés of applications
    final matchesStream = ref.watch(vacancyMatchRepositoryProvider).watchVacancyMatches(vacancyId);

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
      body: StreamBuilder(
        stream: matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text('Erro: ${snapshot.error}'),
                ],
              ),
            );
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhum match ainda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Aguarde barbeiros curtirem esta vaga', textAlign: TextAlign.center),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(match.barberName),
                  subtitle: Text('Match em ${_formatDate(match.createdAt)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () {
                      // TODO: Abrir chat com o barbeiro
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Chat com ${match.barberName} em breve!')));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}
