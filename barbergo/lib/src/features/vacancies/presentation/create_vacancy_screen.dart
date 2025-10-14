import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/enums.dart';
import '../../../domain/entities/vacancy_entity.dart';
import '../../profiles/data/profile_repository.dart';
import '../data/vacancy_repository.dart';

class CreateVacancyScreen extends StatefulWidget {
  const CreateVacancyScreen({super.key});

  @override
  State<CreateVacancyScreen> createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends State<CreateVacancyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _workHoursController = TextEditingController();
  final _commissionController = TextEditingController();

  VacancyType _selectedType = VacancyType.freelancer;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _workHoursController.dispose();
    _commissionController.dispose();
    super.dispose();
  }

  // Validador para campos obrigatórios
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  // Validador para percentual de comissão
  String? _validateCommission(String? value) {
    if (_selectedType != VacancyType.commission) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Percentual de comissão é obrigatório';
    }
    final percentage = double.tryParse(value);
    if (percentage == null || percentage <= 0 || percentage > 100) {
      return 'Insira um percentual válido (1-100)';
    }
    return null;
  }

  // Gera um ID único para a vaga
  String _generateVacancyId() {
    return 'vacancy_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Salva a vaga
  Future<void> _saveVacancy(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Obtém o usuário atual (deve ser uma barbearia)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não está logado');
      }

      // Obtém o perfil da barbearia (necessário para nome e localização)
      final barbershopProfile = await ref.read(userProfileProvider.future);
      if (barbershopProfile == null) {
        throw Exception('Perfil da barbearia não encontrado');
      }

      // Processa o percentual de comissão
      double? commissionPercentage;
      if (_selectedType == VacancyType.commission) {
        commissionPercentage = double.parse(_commissionController.text);
      }

      // Cria o objeto VacancyEntity com campos de desnormalização
      final now = DateTime.now();
      final vacancy = VacancyEntity(
        vacancyId: _generateVacancyId(),
        barbershopId: user.uid,
        barbershopName: barbershopProfile.name,
        title: _titleController.text.trim(),
        type: _selectedType,
        workHours: _workHoursController.text.trim(),
        locationCityState: barbershopProfile.location,
        commissionPercentage: commissionPercentage,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      // Salva a vaga usando o repository
      await ref.read(vacancyRepositoryProvider).createVacancy(vacancy);

      // Mostra mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Vaga publicada com sucesso!'), backgroundColor: Colors.green));

        // Navega de volta para a home
        context.go('/');
      }
    } catch (e) {
      // Mostra erro
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao publicar vaga: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Publicar Vaga'), elevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho
                  const Icon(Icons.work, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Publique sua vaga',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Encontre o barbeiro ideal para sua barbearia',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Campo Título
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título da vaga',
                      hintText: 'Ex: Barbeiro experiente para horário comercial',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateRequired(value, 'Título'),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // Campo Tipo de Vaga
                  DropdownButtonFormField<VacancyType>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de vaga',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    items: VacancyType.values.map((type) {
                      String label;
                      switch (type) {
                        case VacancyType.freelancer:
                          label = 'Freelancer';
                          break;
                        case VacancyType.clt:
                          label = 'CLT';
                          break;
                        case VacancyType.commission:
                          label = 'Comissionado';
                          break;
                      }
                      return DropdownMenuItem(value: type, child: Text(label));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo Horário de Trabalho
                  TextFormField(
                    controller: _workHoursController,
                    decoration: const InputDecoration(
                      labelText: 'Horário de trabalho',
                      hintText: 'Ex: Segunda à Sexta, 9h às 18h',
                      prefixIcon: Icon(Icons.schedule),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateRequired(value, 'Horário'),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // Campo Percentual de Comissão (condicional)
                  if (_selectedType == VacancyType.commission) ...[
                    TextFormField(
                      controller: _commissionController,
                      decoration: const InputDecoration(
                        labelText: 'Percentual de comissão (%)',
                        hintText: 'Ex: 60',
                        prefixIcon: Icon(Icons.percent),
                        border: OutlineInputBorder(),
                        suffixText: '%',
                      ),
                      keyboardType: TextInputType.number,
                      validator: _validateCommission,
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 16),

                  // Botão Publicar
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _saveVacancy(ref),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Publicar Vaga', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),

                  // Botão Cancelar
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            context.go('/');
                          },
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
