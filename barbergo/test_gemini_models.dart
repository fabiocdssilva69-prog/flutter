import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const GeminiModelsApp());
}

class GeminiModelsApp extends StatelessWidget {
  const GeminiModelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Models',
      theme: ThemeData.dark(useMaterial3: true),
      home: const GeminiModelsScreen(),
    );
  }
}

class GeminiModelsScreen extends StatefulWidget {
  const GeminiModelsScreen({super.key});

  @override
  State<GeminiModelsScreen> createState() => _GeminiModelsScreenState();
}

class _GeminiModelsScreenState extends State<GeminiModelsScreen> {
  List<String> _availableModels = [];
  Map<String, String> _testResults = {};
  bool _isLoading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Detectar Modelos Gemini'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.green[900],
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Detectar Modelos Disponíveis',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vamos testar qual modelo funciona com sua API Key',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_error.isNotEmpty)
              Card(
                color: Colors.red[900],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Erro: $_error',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (_availableModels.isNotEmpty) ...[
              Card(
                color: Colors.blue[900],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📋 Modelos para testar:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._availableModels.map((model) {
                        final result = _testResults[model];
                        final icon = result == null
                            ? '⏳'
                            : result.startsWith('✅')
                                ? '✅'
                                : '❌';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '$icon $model ${result ?? ""}',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testAllModels,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Testar Todos os Modelos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _listModels,
              icon: const Icon(Icons.refresh),
              label: const Text('Listar Modelos Disponíveis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Testando modelos...'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _listModels() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _availableModels = [];
    });

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

      if (apiKey.isEmpty || apiKey == 'sua_key_aqui') {
        throw Exception('GEMINI_API_KEY não configurada');
      }

      // Lista de modelos para testar
      final modelsToTest = [
        'gemini-pro',
        'gemini-1.5-pro',
        'gemini-1.5-flash',
        'models/gemini-pro',
        'models/gemini-1.5-pro',
        'models/gemini-1.5-flash',
        'models/gemini-1.5-flash-latest',
        'models/gemini-1.5-pro-latest',
      ];

      setState(() {
        _availableModels = modelsToTest;
        _isLoading = false;
      });

      _showSnackBar('${modelsToTest.length} modelos para testar', Colors.green);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      _showSnackBar('Erro: $e', Colors.red);
    }
  }

  Future<void> _testAllModels() async {
    setState(() {
      _isLoading = true;
      _testResults = {};
    });

    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    for (final modelName in _availableModels) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
        );

        final response =
            await model.generateContent([Content.text('Diga apenas: OK')]);

        final text = response.text ?? '';

        setState(() {
          _testResults[modelName] = '✅ FUNCIONA! ($text)';
        });

        _showSnackBar('✅ $modelName funciona!', Colors.green);
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        setState(() {
          _testResults[modelName] = '❌ Erro';
        });
      }
    }

    setState(() => _isLoading = false);

    // Mostrar resultado final
    final working =
        _testResults.entries.where((e) => e.value.startsWith('✅')).toList();

    if (working.isNotEmpty) {
      final bestModel = working.first.key;
      _showDialog(
        '🎉 Modelo Encontrado!',
        'O modelo que funciona com sua API Key é:\n\n'
            '✅ $bestModel\n\n'
            'Use este modelo no código do BarberGO!',
        Colors.green,
      );
    } else {
      _showDialog(
        '❌ Nenhum Modelo Funcionou',
        'Sua API Key pode estar:\n'
            '1. Inválida ou expirada\n'
            '2. Sem permissões\n'
            '3. De uma região não suportada\n\n'
            'Tente gerar uma nova em:\n'
            'https://makersuite.google.com/app/apikey',
        Colors.orange,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDialog(String title, String message, Color color) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.warning,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: SelectableText(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
