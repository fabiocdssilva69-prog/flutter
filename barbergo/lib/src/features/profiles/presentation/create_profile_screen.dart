import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/enums.dart';
import '../../../domain/entities/profile_entity.dart';
import '../data/profile_repository.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  // Validador para campos obrigatórios
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  // Salva o perfil do barbeiro
  Future<void> _saveProfile(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Obtém o usuário atual
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não está logado');
      }

      // Cria o objeto ProfileEntity
      final profile = ProfileEntity(
        userId: user.uid,
        accountType: AccountType.barber,
        name: _nameController.text.trim(),
        email: user.email!,
        bio: _bioController.text.trim().isEmpty ? '' : _bioController.text.trim(),
        location: _cityController.text.trim(),
        contactPhone: _contactPhoneController.text.trim().isEmpty ? '' : _contactPhoneController.text.trim(),
        createdAt: DateTime.now(),
      );

      // Salva o perfil usando o repository
      await ref.read(profileRepositoryProvider).createProfile(profile);

      // Mostra mensagem de sucesso
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Perfil criado com sucesso!'), backgroundColor: Colors.green));

        // Navega para a home
        context.go('/');
      }
    } catch (e) {
      // Mostra erro
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao criar perfil: $e'), backgroundColor: Colors.red));
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
          appBar: AppBar(title: const Text('Criar Perfil de Barbeiro'), elevation: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho
                  const Icon(Icons.content_cut, size: 64, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Complete seu perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Preencha suas informações para que as barbearias possam conhecê-lo melhor',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Campo Nome
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      hintText: 'Digite seu nome completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateRequired(value, 'Nome'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Campo Bio
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio (opcional)',
                      hintText: 'Conte um pouco sobre você e sua experiência',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // Campo Cidade
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Localização',
                      hintText: 'Em qual cidade você trabalha?',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateRequired(value, 'Localização'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  // Campo Telefone de Contato
                  TextFormField(
                    controller: _contactPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone de contato',
                      hintText: 'Digite seu telefone para contato',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),

                  // Botão Salvar
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _saveProfile(ref),
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
                        : const Text('Salvar Perfil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),

                  // Botão Cancelar (opcional)
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Cancelar criação?'),
                                content: const Text(
                                  'Tem certeza que deseja cancelar? Suas informações serão perdidas.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Continuar editando'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.go('/');
                                    },
                                    child: const Text('Sim, cancelar'),
                                  ),
                                ],
                              ),
                            );
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
