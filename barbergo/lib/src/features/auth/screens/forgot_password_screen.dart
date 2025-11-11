import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/async_value_ui.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../services/firebase_service.dart';
import '../controllers/auth_controller.dart';

/// Tela para recuperação de senha
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(firebaseAnalyticsServiceProvider).logScreenView('forgot_password_screen');
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).resetPassword(_emailController.text.trim());

    if (success && mounted) {
      await ref.read(firebaseAnalyticsServiceProvider).logEvent('password_reset_requested');
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _emailSent ? _buildSuccessView(theme) : _buildFormView(theme, isLoading),
        ),
      ),
    );
  }

  Widget _buildFormView(ThemeData theme, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.lock_reset, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),

          Text(
            'Esqueceu sua senha?',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Digite seu email e enviaremos instruções para redefinir sua senha',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'seu@email.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite seu email';
              }
              if (!value.contains('@')) {
                return 'Email inválido';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          PrimaryButton(text: 'Enviar', onPressed: _handleSubmit, isLoading: isLoading),
        ],
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.mark_email_read, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 24),

        Text(
          'Email Enviado!',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          'Verifique sua caixa de entrada e siga as instruções para redefinir sua senha',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        PrimaryButton(text: 'Voltar ao Login', onPressed: () => Navigator.of(context).pop()),

        const SizedBox(height: 16),

        SecondaryButton(text: 'Reenviar Email', onPressed: () => setState(() => _emailSent = false)),
      ],
    );
  }
}
