import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common_widgets.dart';

/// Tela de verificação de identidade
class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  bool _isVerified = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isVerified) {
      return _buildVerifiedView(theme);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verificação de Identidade')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Ícone
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, shape: BoxShape.circle),
              child: Icon(Icons.verified_user, size: 64, color: theme.colorScheme.primary),
            ),
          ),

          const SizedBox(height: 24),

          // Título
          Text(
            'Verifique sua Identidade',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Aumente sua confiabilidade e receba mais matches com um selo de verificado',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Benefícios
          _buildBenefit(
            theme,
            icon: Icons.verified,
            title: 'Selo de Verificado',
            description: 'Destaque-se com o selo azul de verificado no seu perfil',
          ),

          const SizedBox(height: 16),

          _buildBenefit(
            theme,
            icon: Icons.security,
            title: 'Mais Confiança',
            description: 'Outros usuários saberão que você é quem diz ser',
          ),

          const SizedBox(height: 16),

          _buildBenefit(
            theme,
            icon: Icons.trending_up,
            title: 'Mais Matches',
            description: 'Perfis verificados recebem 2x mais curtidas',
          ),

          const SizedBox(height: 32),

          // Como Funciona
          Text('Como Funciona', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          _buildStep(theme, 1, 'Tire uma selfie'),
          _buildStep(theme, 2, 'Siga as instruções na tela'),
          _buildStep(theme, 3, 'Aguarde a verificação (até 24h)'),
          _buildStep(theme, 4, 'Receba seu selo de verificado!'),

          const SizedBox(height: 32),

          // Botão
          PrimaryButton(
            text: 'Começar Verificação',
            icon: Icons.camera_alt,
            onPressed: _startVerification,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 16),

          // Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Suas fotos de verificação são privadas e não serão compartilhadas',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedView(ThemeData theme) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificação')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, size: 100, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text('Parabéns!', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Sua identidade foi verificada com sucesso',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(text: 'Ver Perfil', onPressed: () => Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(ThemeData theme, {required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: theme.colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(ThemeData theme, int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Future<void> _startVerification() async {
    setState(() => _isLoading = true);

    // TODO: Implementar processo de verificação
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    }
  }
}
