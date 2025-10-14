import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:barbergo_app/src/features/ai/controllers/cv_generator_controller.dart';
import 'package:barbergo_app/src/features/ai/controllers/business_advisor_controller.dart';
import 'package:barbergo_app/src/features/ai/controllers/barber_chatbot_controller.dart';
import 'package:barbergo_app/src/features/ai/controllers/writing_assistant_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IA Completa - BarberGO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  String _selectedTest = 'CV Generator';
  String? _result;
  bool _loading = false;

  final _tests = [
    'CV Generator',
    'Business Advisor',
    'Chatbot',
    'Writing Assistant',
  ];

  Future<void> _runTest() async {
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      String result = '';

      switch (_selectedTest) {
        case 'CV Generator':
          result = await _testCVGenerator();
          break;
        case 'Business Advisor':
          result = await _testBusinessAdvisor();
          break;
        case 'Chatbot':
          result = await _testChatbot();
          break;
        case 'Writing Assistant':
          result = await _testWritingAssistant();
          break;
      }

      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = '❌ ERRO: $e';
        _loading = false;
      });
    }
  }

  Future<String> _testCVGenerator() async {
    // Pega o controller de forma síncrona ANTES do await
    final controller = ref.read(cVGeneratorControllerProvider.notifier);

    final cv = await controller.generateCreativeCV(
      fullName: 'João Silva',
      specialty: 'Fade e Degradê',
      instagram: '@joaobarber',
      topSkills: ['Fade perfeito', 'Barba artística', 'Atendimento premium'],
      portfolio: 'instagram.com/joaobarber',
    );

    return '📝 CURRÍCULO CRIATIVO:\n\n$cv';
  }

  Future<String> _testBusinessAdvisor() async {
    // Pega o controller de forma síncrona ANTES do await
    final controller = ref.read(businessAdvisorControllerProvider.notifier);

    final analysis = await controller.analyzeLocation(
      city: 'São Paulo',
      neighborhood: 'Vila Madalena',
      budget: 'R\$ 50.000',
    );

    return '🏪 ANÁLISE DE LOCALIZAÇÃO:\n\n$analysis';
  }

  Future<String> _testChatbot() async {
    // Pega o controller de forma síncrona ANTES do await
    final controller = ref.read(barberChatbotControllerProvider.notifier);

    final response = await controller.sendMessage(
      message: 'Me dê dicas sobre como fazer um fade perfeito',
    );

    return '💬 CHATBOT:\n\n$response';
  }

  Future<String> _testWritingAssistant() async {
    const textWithErrors =
        'Oi pessoal! Hj vou mostrar um corte top q fiz. Ta muito legal, espero q goste!';

    // Pega o controller de forma síncrona ANTES do await
    final controller = ref.read(writingAssistantControllerProvider.notifier);

    final corrected = await controller.improveWriting(text: textWithErrors);

    return '✍️ TEXTO ORIGINAL:\n$textWithErrors\n\n✅ TEXTO MELHORADO:\n$corrected';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 IA Completa - BarberGO'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🚀 Sistema de IA Expandido',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Aproveitando ao máximo o GPT-4',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Seletor de teste
            DropdownButtonFormField<String>(
              initialValue: _selectedTest,
              decoration: const InputDecoration(
                labelText: 'Escolha o teste',
                border: OutlineInputBorder(),
              ),
              items: _tests.map((test) {
                return DropdownMenuItem(
                  value: test,
                  child: Text(_getTestIcon(test)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTest = value!;
                  _result = null;
                });
              },
            ),

            const SizedBox(height: 16),

            // Descrição do teste
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                _getTestDescription(_selectedTest),
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),

            // Botão de teste
            ElevatedButton.icon(
              onPressed: _loading ? null : _runTest,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_loading ? 'Processando...' : 'Testar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 24),

            // Resultado
            if (_result != null)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _result!.contains('❌')
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _result!.contains('❌') ? Colors.red : Colors.green,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _result!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getTestIcon(String test) {
    switch (test) {
      case 'CV Generator':
        return '📝 Gerador de Currículos';
      case 'Business Advisor':
        return '🏪 Consultor de Negócios';
      case 'Chatbot':
        return '💬 Chatbot Artístico';
      case 'Writing Assistant':
        return '✍️ Assistente de Escrita';
      default:
        return test;
    }
  }

  String _getTestDescription(String test) {
    switch (test) {
      case 'CV Generator':
        return 'Gera currículos criativos e profissionais para barbeiros, '
            'destacando especialidades e portfólio.';
      case 'Business Advisor':
        return 'Analisa localização, viabilidade, precificação e estratégias '
            'de marketing para barbearias.';
      case 'Chatbot':
        return 'Chatbot conversacional especializado em técnicas, tendências, '
            'produtos e o mundo artístico de cabelos e barbas.';
      case 'Writing Assistant':
        return 'Corrige ortografia, melhora escrita, gera ideias de posts e '
            'legendas para redes sociais.';
      default:
        return '';
    }
  }
}
