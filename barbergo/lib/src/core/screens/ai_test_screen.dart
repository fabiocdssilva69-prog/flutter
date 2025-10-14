import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:openai_dart/openai_dart.dart';

/// Tela de teste para verificar se as API keys estão configuradas corretamente
class AITestScreen extends StatefulWidget {
  const AITestScreen({super.key});

  @override
  State<AITestScreen> createState() => _AITestScreenState();
}

class _AITestScreenState extends State<AITestScreen> {
  String _geminiStatus = 'Aguardando teste...';
  String _openaiStatus = 'Aguardando teste...';
  String _claudeStatus = 'Aguardando teste...';
  String _testResult = '';
  bool _isTesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Teste de API Keys IA'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.smart_toy, size: 48, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Teste de Integração IA',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Verifique se suas API keys estão funcionando',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status das APIs
            _buildStatusCard(
              title: '🟢 Gemini API',
              subtitle: 'Google One Ultra - GRÁTIS',
              status: _geminiStatus,
              color: Colors.green,
            ),

            const SizedBox(height: 12),

            _buildStatusCard(
              title: '🔵 OpenAI API',
              subtitle: 'GPT-4 Pro - Incluído',
              status: _openaiStatus,
              color: Colors.blue,
            ),

            const SizedBox(height: 12),

            _buildStatusCard(
              title: '🟣 Claude API',
              subtitle: 'Anthropic - ~\$5/mês',
              status: _claudeStatus,
              color: Colors.purple,
            ),

            const SizedBox(height: 24),

            // Resultado do teste
            if (_testResult.isNotEmpty) ...[
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.psychology, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text(
                            'Resultado do Teste',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(_testResult, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Botões de teste
            ElevatedButton.icon(
              onPressed: _isTesting ? null : _testGemini,
              icon: const Icon(Icons.check_circle),
              label: const Text('Testar Gemini (Geração de Texto)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isTesting ? null : _testAllApis,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Testar Todas as APIs'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            if (_isTesting)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String subtitle,
    required String status,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.api, color: color),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 13,
                      color: status.contains('✅')
                          ? Colors.green
                          : status.contains('❌')
                          ? Colors.red
                          : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testGemini() async {
    setState(() {
      _isTesting = true;
      _geminiStatus = '⏳ Testando...';
      _testResult = '';
    });

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

      if (apiKey.isEmpty || apiKey == 'sua_key_aqui') {
        throw Exception('GEMINI_API_KEY não configurada no arquivo .env');
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      final prompt =
          'Escreva uma bio profissional de 2 linhas para um barbeiro chamado João Silva, especialista em Fade e Degradê, com 5 anos de experiência em São Paulo.';
      final response = await model.generateContent([Content.text(prompt)]);

      final bio = response.text ?? 'Nenhuma resposta gerada';

      setState(() {
        _geminiStatus = '✅ Funcionando!';
        _testResult = 'Bio gerada com sucesso:\n\n$bio';
        _isTesting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Gemini funcionando perfeitamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _geminiStatus = '❌ Erro';
        _testResult =
            'Erro ao testar Gemini:\n\n$e\n\nVerifique se a GEMINI_API_KEY está correta no arquivo .env';
        _isTesting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro no Gemini: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _testAllApis() async {
    setState(() {
      _isTesting = true;
      _geminiStatus = '⏳ Testando...';
      _openaiStatus = '⏳ Testando...';
      _claudeStatus = '⏳ Testando...';
      _testResult = '';
    });

    // Teste Gemini
    try {
      final geminiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (geminiKey.isEmpty || geminiKey == 'sua_key_aqui') {
        throw Exception('Key não configurada');
      }
      final geminiModel = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: geminiKey,
      );
      await geminiModel.generateContent([Content.text('teste')]);
      setState(() => _geminiStatus = '✅ Configurado!');
    } catch (e) {
      setState(
        () => _geminiStatus = '❌ Erro: ${e.toString().substring(0, 50)}...',
      );
    }

    // Teste OpenAI
    try {
      final openaiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
      if (openaiKey.isEmpty || openaiKey == 'sua_key_aqui') {
        throw Exception('Key não configurada');
      }
      final openaiClient = OpenAIClient(apiKey: openaiKey);
      await openaiClient.listModels();
      setState(() => _openaiStatus = '✅ Configurado!');
    } catch (e) {
      setState(
        () => _openaiStatus = '❌ Erro: ${e.toString().substring(0, 50)}...',
      );
    }

    // Teste Claude
    try {
      final claudeKey = dotenv.env['ANTHROPIC_API_KEY'] ?? '';
      if (claudeKey.isEmpty || claudeKey == 'sua_key_aqui') {
        throw Exception('Key não configurada');
      }
      // Claude não tem método simples de verificação, apenas validamos se key existe
      setState(() => _claudeStatus = '✅ Key configurada (não testada)');
    } catch (e) {
      setState(
        () => _claudeStatus = '❌ Erro: ${e.toString().substring(0, 50)}...',
      );
    }

    // Resultado final
    final allOk =
        _geminiStatus.contains('✅') &&
        _openaiStatus.contains('✅') &&
        _claudeStatus.contains('✅');

    setState(() {
      _testResult = allOk
          ? '🎉 Todas as APIs estão configuradas corretamente!\n\nVocê pode usar:\n• Geração de Bio (Gemini)\n• Smart Matching (GPT-4)\n• Análise de Portfólio (Gemini Vision)\n• Geração de Contratos (Claude)'
          : '⚠️ Algumas APIs não estão configuradas.\n\nVerifique o arquivo .env e adicione as chaves que estão faltando.';
      _isTesting = false;
    });
  }
}
