import 'package:barbergo_app/src/domain/entities/application_entity.dart';
import 'package:barbergo_app/src/domain/entities/enums.dart';
import 'package:barbergo_app/src/domain/entities/vacancy_entity.dart';
import 'package:barbergo_app/src/features/auth/controllers/auth_controller.dart';
import 'package:barbergo_app/src/features/auth/providers/auth_providers.dart';
import 'package:barbergo_app/src/features/vacancies/application/vacancy_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class VacancyDetailScreen extends ConsumerWidget {
  const VacancyDetailScreen({super.key, required this.vacancyId});

  final String vacancyId;

  /// Helper para montar a tela a partir do estado da rota do [GoRouter].
  static VacancyDetailScreen fromRoute(GoRouterState state) {
    final vacancyId = state.pathParameters['vacancyId'];
    if (vacancyId == null || vacancyId.isEmpty) {
      throw ArgumentError('O parâmetro "vacancyId" é obrigatório na rota.');
    }

    return VacancyDetailScreen(vacancyId: vacancyId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vacancyAsync = ref.watch(vacancyByIdProvider(vacancyId));
    final accountType = ref.watch(currentAccountTypeProvider);
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.asData?.value?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da vaga')),
      body: vacancyAsync.when(
        data: (vacancy) {
          if (vacancy == null) {
            return const Center(child: Text('Vaga não encontrada'));
          }
          return _VacancyDetailContent(
            vacancy: vacancy,
            barberId: currentUserId,
            showApplyButton: accountType == AccountType.barber && currentUserId != null,
          );
        },
        error: (error, stackTrace) => _VacancyDetailError(error: error),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _VacancyDetailContent extends StatelessWidget {
  const _VacancyDetailContent({required this.vacancy, required this.barberId, required this.showApplyButton});

  final VacancyEntity vacancy;
  final String? barberId;
  final bool showApplyButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(vacancy.title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Código da vaga: ${vacancy.vacancyId}',
                style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DetailItem(label: 'Tipo de contratação', value: _mapVacancyType(vacancy.type)),
                      _DetailItem(label: 'Horário de trabalho', value: vacancy.workHours),
                      _DetailItem(
                        label: 'Comissão',
                        value: vacancy.commissionPercentage != null
                            ? '${vacancy.commissionPercentage!.toStringAsFixed(0)}%'
                            : 'Não informada',
                      ),
                      _DetailItem(label: 'Status', value: vacancy.isActive ? 'Vaga ativa' : 'Vaga encerrada'),
                      _DetailItem(label: 'Barbearia', value: vacancy.barbershopId),
                      _DetailItem(label: 'Criada em', value: dateFormat.format(vacancy.createdAt)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Descrição', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                'A barbearia ainda não forneceu uma descrição detalhada para esta vaga.',
                style: textTheme.bodyMedium,
              ),
              if (showApplyButton) ...[const SizedBox(height: 32), _ApplyButton(vacancy: vacancy, barberId: barberId)],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ApplyButton extends ConsumerStatefulWidget {
  const _ApplyButton({required this.vacancy, required this.barberId});

  final VacancyEntity vacancy;
  final String? barberId;

  @override
  ConsumerState<_ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends ConsumerState<_ApplyButton> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isSubmitting ? null : () => _handleApply(context),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        icon: _isSubmitting
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                ),
              )
            : const Icon(Icons.assignment_turned_in_outlined, size: 28),
        label: Text(_isSubmitting ? 'Enviando candidatura...' : 'Quero me candidatar!'),
      ),
    );
  }

  Future<void> _handleApply(BuildContext context) async {
    final barberId = widget.barberId;
    if (barberId == null || barberId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Não foi possível identificar seu perfil de barbeiro.')));
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // TODO: Implement application creation with the new architecture
    final application = ApplicationEntity(
      applicationId: DateTime.now().microsecondsSinceEpoch.toString(),
      vacancyId: widget.vacancy.vacancyId,
      barberId: barberId,
      barbershopId: widget.vacancy.barbershopId,
      barbershopName: widget.vacancy.barbershopName,
      status: ApplicationStatus.pending,
      createdAt: DateTime.now(),
    );

    try {
      // TODO: Implement repository call for creating applications
      // await repository.createApplication(application);

      // For now, show success to test the UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Candidatura enviada com sucesso! (Funcionalidade em desenvolvimento)')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Não foi possível enviar a candidatura. Tente novamente.\n$error')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _VacancyDetailError extends StatelessWidget {
  const _VacancyDetailError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              'Não foi possível carregar os detalhes da vaga.',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('$error', style: textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

String _mapVacancyType(VacancyType type) {
  switch (type) {
    case VacancyType.freelancer:
      return 'Freelancer';
    case VacancyType.clt:
      return 'CLT';
    case VacancyType.commission:
      return 'Comissionado';
  }
}
