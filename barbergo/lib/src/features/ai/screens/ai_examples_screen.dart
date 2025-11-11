import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ai_orchestrator_service.dart';

/// 🎯 Exemplos práticos de uso do AI Orchestrator
/// Mostra como usar as 3 IAs de forma inteligente no BarberGO

class AIExamplesScreen extends ConsumerStatefulWidget {
  const AIExamplesScreen({super.key});

  @override
  ConsumerState<AIExamplesScreen> createState() => _AIExamplesScreenState();
}

class _AIExamplesScreenState extends ConsumerState<AIExamplesScreen> {
  String _result = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎯 AI Orchestrator - Exemplos'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Card(
              color: Colors.deepPurple,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.psychology, size: 48, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      '3 IAs Trabalhando Juntas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text('Cada uma no que faz de melhor!', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Exemplo 1: Bio Inteligente (Gemini)
            _buildExampleCard(
              title: '📝 Gerar Bio Profissional',
              subtitle: 'Usa: 🟢 GEMINI (rápido e criativo)',
              icon: Icons.person,
              color: Colors.green,
              onTap: _generateBio,
            ),

            const SizedBox(height: 12),

            // Exemplo 2: Smart Matching (GPT-4)
            _buildExampleCard(
              title: '🎯 Smart Matching',
              subtitle: 'Usa: 🔵 GPT-4 (precisão lógica)',
              icon: Icons.analytics,
              color: Colors.blue,
              onTap: _calculateMatching,
            ),

            const SizedBox(height: 12),

            // Exemplo 3: Buscar Tendências (Perplexity)
            _buildExampleCard(
              title: '📈 Buscar Tendências',
              subtitle: 'Usa: 🟠 PERPLEXITY (dados atualizados)',
              icon: Icons.trending_up,
              color: Colors.orange,
              onTap: _searchTrends,
            ),

            const SizedBox(height: 12),

            // Exemplo 4: Combo Inteligente
            _buildExampleCard(
              title: '🏆 Bio Inteligente (COMBO)',
              subtitle: 'Usa: 🟠 Perplexity + 🟢 Gemini',
              icon: Icons.rocket_launch,
              color: Colors.purple,
              onTap: _generateSmartBio,
            ),

            const SizedBox(height: 24),

            // Resultado
            if (_result.isNotEmpty) ...[
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.amber),
                          SizedBox(width: 8),
                          Text('Resultado:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(_result, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1 * 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🎯 EXEMPLOS PRÁTICOS
  // ============================================================

  /// 📝 Exemplo 1: Gerar Bio com Gemini (rápido e criativo)
  Future<void> _generateBio() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final orchestrator = ref.read(aIOrchestratorProvider.notifier);

      final bio = await orchestrator.executeTask(
        task: AITask.bioGeneration,
        prompt: '''
Nome: João Silva
Especialidades: Fade, Degradê, Barba Desenhada
Experiência: 5 anos
Cidade: São Paulo
Diferencial: Atendimento VIP e música ao vivo
''',
      );

      setState(() {
        _result = '🟢 GEMINI gerou em <1s:\n\n$bio';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Bio gerada com Gemini (rápido!)'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() {
        _result = '❌ Erro: $e';
        _isLoading = false;
      });
    }
  }

  /// 🎯 Exemplo 2: Smart Matching com GPT-4 (precisão)
  Future<void> _calculateMatching() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final orchestrator = ref.read(aIOrchestratorProvider.notifier);

      final match = await orchestrator.executeTask(
        task: AITask.smartMatching,
        prompt: '''
BARBEIRO:
- Nome: João Silva
- Especialidades: Fade, Degradê, Barba
- Experiência: 5 anos
- Avaliação: 4.8/5 (120 reviews)
- Preço médio: R\$ 45
- Localização: Pinheiros, São Paulo

CLIENTE:
- Nome: Carlos Mendes
- Idade: 28 anos
- Preferência: Corte moderno para entrevista de emprego
- Orçamento: até R\$ 50
- Urgência: hoje ou amanhã
- Localização: Vila Madalena, São Paulo
''',
      );

      setState(() {
        _result = '🔵 GPT-4 analisou com precisão:\n\n$match';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Match calculado com GPT-4 (preciso!)'), backgroundColor: Colors.blue),
        );
      }
    } catch (e) {
      setState(() {
        _result = '❌ Erro: $e';
        _isLoading = false;
      });
    }
  }

  /// 📈 Exemplo 3: Buscar Tendências com Perplexity (dados atuais)
  Future<void> _searchTrends() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final orchestrator = ref.read(aIOrchestratorProvider.notifier);

      final trends = await orchestrator.executeTask(
        task: AITask.trendSearch,
        prompt: 'Cortes de cabelo masculino mais procurados em 2024 no Brasil',
      );

      setState(() {
        _result = '🟠 PERPLEXITY buscou na web:\n\n$trends';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Tendências buscadas com Perplexity (atualizado!)'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _result = '❌ Erro: $e';
        _isLoading = false;
      });
    }
  }

  /// 🏆 Exemplo 4: Bio Inteligente - COMBO (Perplexity + Gemini)
  Future<void> _generateSmartBio() async {
    setState(() {
      _isLoading = true;
      _result = 'Executando combo:\n1️⃣ Perplexity buscando tendências...\n';
    });

    try {
      final orchestrator = ref.read(aIOrchestratorProvider.notifier);

      // PASSO 1: Buscar tendências (Perplexity)
      setState(() {
        _result += '2️⃣ Gemini gerando bio personalizada...\n';
      });

      // COMBO AUTOMÁTICO!
      final smartBio = await orchestrator.generateSmartBio(
        barberName: 'João Silva',
        specialties: ['Fade', 'Degradê', 'Barba Desenhada'],
        yearsExperience: 5,
        city: 'São Paulo',
      );

      setState(() {
        _result =
            '🏆 COMBO (Perplexity + Gemini):\n\n$smartBio\n\n'
            '✨ Bio personalizada + atualizada com tendências reais!';
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Smart Bio gerada! (Combo de 2 IAs)'),
            backgroundColor: Colors.purple,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _result = '❌ Erro: $e';
        _isLoading = false;
      });
    }
  }
}
