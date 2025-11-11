import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/async_value_ui.dart';
import '../../../core/utils/form_validators.dart';
import '../../../services/firebase_service.dart';
import '../controllers/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    // Log Analytics: Usuário visualizou tela de cadastro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(firebaseAnalyticsServiceProvider).logScreenView('signup_screen');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      // Chama o AuthController para realizar o registro
      final success = await ref
          .read(authControllerProvider.notifier)
          .signUp(_emailController.text, _passwordController.text);

      // Log Analytics: Usuário criou conta com sucesso
      if (success) {
        await ref.read(firebaseAnalyticsServiceProvider).logEvent('sign_up', parameters: {'method': 'email'});
      }

      // Se sucesso, navegamos explicitamente para o onboarding.
      // O GoRouter automático nos levaria para a Home, mas queremos forçar o onboarding após o registro.
      if (success && mounted) {
        context.go('/onboarding/select-account');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa erros e mostra o AlertDialog
    ref.listen(authControllerProvider, (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Conta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Comece sua jornada no BarberGO',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              // E-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                validator: FormValidators.email,
              ),
              const SizedBox(height: 16),
              // Senha
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha (mín 8 caracteres, letra + número)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordObscured ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
                obscureText: _isPasswordObscured,
                enabled: !isLoading,
                validator: FormValidators.strongPassword,
              ),
              const SizedBox(height: 16),
              // Confirmar Senha
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: _isPasswordObscured,
                enabled: !isLoading,
                validator: (value) => FormValidators.confirmPassword(value, _passwordController.text),
              ),
              const SizedBox(height: 32),
              // Botão Registrar
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: AppColors.background)
                    : const Text("CADASTRAR"),
              ),
              const SizedBox(height: 16),
              // Link Voltar ao Login
              TextButton(
                onPressed: isLoading ? null : () => context.go('/login'),
                child: const Text("Já tenho conta (Login)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
