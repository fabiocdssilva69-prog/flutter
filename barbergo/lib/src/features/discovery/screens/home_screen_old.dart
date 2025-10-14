import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../auth/application/account_type_provider.dart';
import '../../vacancies/data/vacancy_repository.dart';
import '../../profiles/data/profile_repository.dart';
import '../../applications/application/application_providers.dart';
import '../../../domain/entities/enums.dart';

// Mude de StatelessWidget para ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Widget para card de candidatura individual (para barbearias)
  Widget _buildApplicationCard(
    dynamic application,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nova Candidatura',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(application.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusLabel(application.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Informações da vaga
            FutureBuilder(
              future: ref
                  .read(vacancyRepositoryProvider)
                  .getVacancyById(application.vacancyId),
              builder: (context, vacancySnapshot) {
                if (vacancySnapshot.hasData) {
                  final vacancy = vacancySnapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vaga: ${vacancy.title}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tipo: ${_getVacancyTypeLabel(vacancy.type)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                } else if (vacancySnapshot.hasError) {
                  return const Text(
                    'Erro ao carregar dados da vaga',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return const Text(
                    'Carregando dados da vaga...',
                    style: TextStyle(color: Colors.grey),
                  );
                }
              },
            ),

            const SizedBox(height: 8),

            // Informações do barbeiro
            FutureBuilder(
              future: ref
                  .read(profileRepositoryProvider)
                  .getUserProfile(application.barberId),
              builder: (context, barberSnapshot) {
                if (barberSnapshot.hasData) {
                  final barber = barberSnapshot.data!;
                  return Text(
                    'Barbeiro: ${barber.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else if (barberSnapshot.hasError) {
                  return const Text(
                    'Erro ao carregar dados do barbeiro',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return const Text(
                    'Carregando dados do barbeiro...',
                    style: TextStyle(color: Colors.grey),
                  );
                }
              },
            ),

            const SizedBox(height: 8),

            // Data da candidatura
            Text(
              'Candidatura enviada em ${_formatDate(application.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Cores para diferentes status de candidatura
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Labels para diferentes status
  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendente';
      case 'approved':
        return 'Aprovada';
      case 'rejected':
        return 'Rejeitada';
      default:
        return 'Desconhecido';
    }
  }

  // Label para tipo de vaga
  String _getVacancyTypeLabel(VacancyType type) {
    switch (type) {
      case VacancyType.freelancer:
        return 'Freelancer';
      case VacancyType.clt:
        return 'CLT';
      case VacancyType.commission:
        return 'Comissionado';
    }
  }

  // Widget para card de vaga individual
  Widget _buildVacancyCard(dynamic vacancy, BuildContext context) {
    String typeLabel;
    switch (vacancy.type) {
      case VacancyType.freelancer:
        typeLabel = 'Freelancer';
        break;
      case VacancyType.clt:
        typeLabel = 'CLT';
        break;
      case VacancyType.commission:
        typeLabel = 'Comissionado';
        break;
      default:
        typeLabel = 'Outro';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.go('/vacancies/${vacancy.vacancyId}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título da vaga
              Text(
                vacancy.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Tipo de vaga
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(vacancy.type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  typeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Horário de trabalho
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      vacancy.workHours,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              // Comissão (se aplicável)
              if (vacancy.type == VacancyType.commission &&
                  vacancy.commissionPercentage != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.percent, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Comissão: ${vacancy.commissionPercentage}%',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),

              // Data de publicação
              Text(
                'Publicado em ${_formatDate(vacancy.createdAt)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Cores para diferentes tipos de vaga
  Color _getTypeColor(VacancyType type) {
    switch (type) {
      case VacancyType.freelancer:
        return Colors.blue;
      case VacancyType.clt:
        return Colors.green;
      case VacancyType.commission:
        return Colors.orange;
    }
  }

  // Formatar data
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa o tipo de conta do usuário
    final accountType = ref.watch(currentAccountTypeProvider);
    final currentUserId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          accountType == AccountType.barbershop
              ? "Candidaturas Recebidas"
              : "BarberGO",
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: _buildBodyBasedOnAccountType(
        context,
        ref,
        accountType,
        currentUserId,
      ),

      // FloatingActionButton apenas para barbearias
      floatingActionButton: accountType == AccountType.barbershop
          ? FloatingActionButton(
              onPressed: () {
                context.go('/vacancies/create');
              },
              tooltip: 'Publicar Vaga',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBodyBasedOnAccountType(
    BuildContext context,
    WidgetRef ref,
    AccountType? accountType,
    String? currentUserId,
  ) {
    if (accountType == AccountType.barbershop && currentUserId != null) {
      // Para barbearias: mostrar candidaturas recebidas
      return _buildApplicationsView(context, ref, currentUserId);
    } else {
      // Para barbeiros: mostrar feed de vagas (comportamento atual)
      return _buildVacancyFeedView(context, ref);
    }
  }

  Widget _buildApplicationsView(
    BuildContext context,
    WidgetRef ref,
    String barbershopId,
  ) {
    final applicationsAsync = ref.watch(
      barbershopApplicationsProvider(barbershopId),
    );

    return applicationsAsync.when(
      // Estado de carregamento
      loading: () => const Center(child: CircularProgressIndicator()),

      // Estado de erro
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Erro ao carregar candidaturas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(barbershopApplicationsProvider(barbershopId));
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),

      // Estado com dados
      data: (applications) {
        if (applications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhuma candidatura recebida',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'As candidaturas para suas vagas aparecerão aqui!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(barbershopApplicationsProvider(barbershopId));
          },
          child: ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              return _buildApplicationCard(application, context, ref);
            },
          ),
        );
      },
    );
  }

  Widget _buildVacancyFeedView(BuildContext context, WidgetRef ref) {
    // Observa o stream de vagas ativas (comportamento original)
    final vacanciesAsync = ref.watch(activeVacanciesProvider);

    return vacanciesAsync.when(
      // Estado de carregamento
      loading: () => const Center(child: CircularProgressIndicator()),

      // Estado de erro
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Erro ao carregar vagas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Força o reload do provider
                ref.invalidate(activeVacanciesProvider);
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),

      // Estado com dados
      data: (vacancies) {
        if (vacancies.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhuma vaga disponível',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Seja o primeiro a publicar uma vaga!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeVacanciesProvider);
          },
          child: ListView.builder(
            itemCount: vacancies.length,
            itemBuilder: (context, index) {
              final vacancy = vacancies[index];
              return _buildVacancyCard(vacancy, context);
            },
          ),
        );
      },
    );
  }
}
