import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega o .env
  await dotenv.load(fileName: '.env');

  runApp(const AITestApp());
}

class AITestApp extends StatelessWidget {
  const AITestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste de API Keys',
      theme: ThemeData.dark(),
      home: const AITestHomeScreen(),
    );
  }
}

class AITestHomeScreen extends StatefulWidget {
  const AITestHomeScreen({super.key});

  @override
  State<AITestHomeScreen> createState() => _AITestHomeScreenState();
}

class _AITestHomeScreenState extends State<AITestHomeScreen> {
  String _geminiKey = '';
  String _openaiKey = '';
  String _claudeKey = '';
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  void _loadKeys() {
    setState(() {
      _geminiKey = dotenv.env['GEMINI_API_KEY'] ?? 'NÃO ENCONTRADA';
      _openaiKey = dotenv.env['OPENAI_API_KEY'] ?? 'NÃO ENCONTRADA';
      _claudeKey = dotenv.env['ANTHROPIC_API_KEY'] ?? 'NÃO ENCONTRADA';

      if (_geminiKey == 'sua_key_aqui') {
        _geminiKey = '⚠️ PLACEHOLDER NÃO SUBSTITUÍDO';
      }
      if (_openaiKey == 'sua_key_aqui') {
        _openaiKey = '⚠️ PLACEHOLDER NÃO SUBSTITUÍDO';
      }
      if (_claudeKey == 'sua_key_aqui') {
        _claudeKey = '⚠️ PLACEHOLDER NÃO SUBSTITUÍDO';
      }

      _status = 'API Keys carregadas com sucesso!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Teste de API Keys'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.smart_toy, size: 64, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Verificação de API Keys',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Verifique se suas chaves foram carregadas corretamente',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_status.isNotEmpty)
              Card(
                color: Colors.green[900],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.greenAccent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _status,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _buildKeyCard(
              title: '🟢 Gemini API',
              subtitle: 'Google Generative AI',
              keyValue: _geminiKey,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildKeyCard(
              title: '🔵 OpenAI API',
              subtitle: 'GPT-4',
              keyValue: _openaiKey,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildKeyCard(
              title: '🟣 Claude API',
              subtitle: 'Anthropic',
              keyValue: _claudeKey,
              color: Colors.purple,
            ),
            const SizedBox(height: 32),
            Card(
              color: Colors.orange[900],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orangeAccent),
                        SizedBox(width: 12),
                        Text(
                          'Instruções',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Verifique se as chaves foram carregadas\n'
                      '2. Se aparecer "NÃO ENCONTRADA", edite o arquivo .env\n'
                      '3. Se aparecer "PLACEHOLDER", substitua "sua_key_aqui"\n'
                      '4. Após editar, recarregue o app (hot restart)',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadKeys,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Recarregar Keys'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyCard({
    required String title,
    required String subtitle,
    required String keyValue,
    required Color color,
  }) {
    final bool isValid = !keyValue.contains('NÃO ENCONTRADA') &&
        !keyValue.contains('PLACEHOLDER');
    final String maskedKey = isValid && keyValue.length > 10
        ? '${keyValue.substring(0, 8)}...${keyValue.substring(keyValue.length - 4)}'
        : keyValue;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.vpn_key, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isValid ? Icons.check_circle : Icons.error,
                  color: isValid ? Colors.green : Colors.red,
                  size: 32,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                Expanded(
                  child: Text(
                    isValid ? 'Configurada ✅' : 'Não configurada ❌',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isValid ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isValid ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: SelectableText(
                maskedKey,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
