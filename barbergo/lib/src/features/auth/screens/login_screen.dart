import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/async_value_ui.dart'; // Importação adicionada
import '../../../services/firebase_service.dart';
import '../controllers/auth_controller.dart'; // Importação adicionada

// Mude para ConsumerStatefulWidget para gerenciar o estado do formulário
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true; // Para controlar a visibilidade da senha

  @override
  void initState() {
    super.initState();
    // Log Analytics: Usuário visualizou tela de login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(firebaseAnalyticsServiceProvider).logScreenView('login_screen');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _submit() async {
    if (_formKey.currentState!.validate()) {
      // Chama o AuthController para realizar o login
      await ref.read(authControllerProvider.notifier).signIn(_emailController.text, _passwordController.text);

      // Log Analytics: Usuário fez login com sucesso
      await ref.read(firebaseAnalyticsServiceProvider).logLogin('email');

      // Se sucesso, o GoRouter (app_router.dart) redirecionará automaticamente.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa o estado do AuthController e mostra alertas de erro automaticamente
    ref.listen(authControllerProvider, (_, state) => state.showAlertDialogOnError(context));

    // Obtém o estado atual para controlar o carregamento
    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Placeholder
                  const Text(
                    'BarberGO',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Conectando profissionais e barbearias.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  // Campo de E-mail
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                    validator: (value) => (value == null || !value.contains('@')) ? 'Digite um e-mail válido' : null,
                  ),
                  const SizedBox(height: 16),
                  // Campo de Senha
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      // Botão de visibilidade da senha
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
                    validator: (value) => (value == null || value.isEmpty) ? 'A senha não pode ser vazia' : null,
                  ),
                  const SizedBox(height: 32),
                  // Botão de Login
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background, // Cor do texto/ícone
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                          )
                        : const Text('ENTRAR', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  // Botão de retry se houver erro
                  if (state.hasError)
                    TextButton(
                      onPressed: _submit,
                      style: TextButton.styleFrom(foregroundColor: Colors.orange),
                      child: const Text('Tentar Novamente'),
                    ),
                  const SizedBox(height: 24),
                  // Link para Cadastro
                  TextButton(
                    // Navega para a tela de registro
                    onPressed: isLoading ? null : () => context.go('/signup'),
                    child: const Text('Ainda não tem conta? Cadastre-se'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
