import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/async_value_ui.dart';
import '../../../domain/entities/enums.dart';
import '../../../services/firebase_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/onboarding_controller.dart';

// Mudar para ConsumerStatefulWidget para gerenciar o formulário
class AccountTypeSelectionScreen extends ConsumerStatefulWidget {
  const AccountTypeSelectionScreen({super.key});

  @override
  ConsumerState<AccountTypeSelectionScreen> createState() => _AccountTypeSelectionScreenState();
}

class _AccountTypeSelectionScreenState extends ConsumerState<AccountTypeSelectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  AccountType? _selectedAccountType;

  @override
  void initState() {
    super.initState();
    // Log Analytics: Usuário visualizou tela de seleção de tipo de conta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(firebaseAnalyticsServiceProvider).logScreenView('onboarding_account_type');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedAccountType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecione um tipo de conta.")));
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Log Analytics: Usuário completou onboarding
      await ref
          .read(firebaseAnalyticsServiceProvider)
          .logEvent(
            'onboarding_completed',
            parameters: {
              'account_type': _selectedAccountType == AccountType.barber ? 'barber' : 'barbershop',
              'location': _cityController.text,
            },
          );

      await ref
          .read(onboardingControllerProvider.notifier)
          .completeOnboarding(
            accountType: _selectedAccountType!,
            name: _nameController.text,
            location: _cityController.text,
          );
      // Se sucesso, o app_router redirecionará automaticamente para a Home.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa erros do OnboardingController
    ref.listen<AsyncValue<void>>(onboardingControllerProvider, (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(onboardingControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuração Inicial"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cancelar Cadastro',
            onPressed: isLoading
                ? null
                : () {
                    ref.read(authControllerProvider.notifier).signOut();
                  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Como você usará o BarberGO?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Seleção de Tipo de Conta (Radio Buttons)
              RadioListTile<AccountType>(
                title: const Text("Sou Barbeiro (Profissional)"),
                subtitle: const Text("Busco oportunidades de trabalho."),
                value: AccountType.barber,
                groupValue: _selectedAccountType,
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() => _selectedAccountType = value);
                      },
              ),
              RadioListTile<AccountType>(
                title: const Text("Sou Dono de Barbearia"),
                subtitle: const Text("Busco profissionais para minha equipe."),
                value: AccountType.barbershop,
                groupValue: _selectedAccountType,
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() => _selectedAccountType = value);
                      },
              ),

              const Divider(height: 48),

              // Campos de Informações Básicas
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Seu Nome ou Nome da Barbearia",
                  border: OutlineInputBorder(),
                ),
                enabled: !isLoading,
                validator: (v) => (v == null || v.isEmpty) ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "Localização", border: OutlineInputBorder()),
                enabled: !isLoading,
                validator: (v) => (v == null || v.isEmpty) ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 32),

              // Botão de Confirmação
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: AppColors.background)
                    : const Text("SALVAR E CONTINUAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
