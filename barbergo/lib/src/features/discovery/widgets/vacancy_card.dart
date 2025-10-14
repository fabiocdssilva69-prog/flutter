import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/vacancy_entity.dart';
import '../../../domain/entities/enums.dart';

class VacancyCard extends StatelessWidget {
  const VacancyCard({super.key, required this.vacancy});

  final VacancyEntity vacancy;

  String _formatVacancyType(VacancyType type) {
    switch (type) {
      case VacancyType.freelancer:
        return 'Freelance';
      case VacancyType.clt:
        return 'CLT';
      case VacancyType.commission:
        return 'Comissão';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo de vaga em destaque
            Chip(
              label: Text(
                _formatVacancyType(vacancy.type),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.primary,
            ),
            const SizedBox(height: 16),

            // Título da vaga
            Text(
              vacancy.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Detalhes da vaga
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.schedule,
                color: AppColors.primary,
              ),
              title: const Text('Horário'),
              subtitle: Text(vacancy.workHours),
            ),

            if (vacancy.type == VacancyType.commission &&
                vacancy.commissionPercentage != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.attach_money,
                  color: AppColors.primary,
                ),
                title: const Text('Comissão'),
                subtitle: Text('${vacancy.commissionPercentage}%'),
              ),

            const Spacer(),

            // Data de criação
            Text(
              'Publicado em ${_formatDate(vacancy.createdAt)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
