import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/common_widgets.dart';

/// Quiz de Compatibilidade
class CompatibilityQuizScreen extends ConsumerStatefulWidget {
  const CompatibilityQuizScreen({super.key});

  @override
  ConsumerState<CompatibilityQuizScreen> createState() => _CompatibilityQuizScreenState();
}

class _CompatibilityQuizScreenState extends ConsumerState<CompatibilityQuizScreen> {
  int _currentQuestion = 0;
  final Map<int, int> _answers = {};

  final _questions = [
    {
      'question': 'Qual é o seu tipo de encontro ideal?',
      'options': ['Jantar romântico', 'Cinema e pipoca', 'Aventura ao ar livre', 'Evento cultural'],
    },
    {
      'question': 'Como você prefere passar o fim de semana?',
      'options': ['Em casa relaxando', 'Explorando novos lugares', 'Com amigos', 'Praticando hobbies'],
    },
    {
      'question': 'O que é mais importante para você?',
      'options': ['Honestidade', 'Senso de humor', 'Ambição', 'Gentileza'],
    },
    {
      'question': 'Qual seu estilo de comunicação?',
      'options': ['Direto e objetivo', 'Expressivo e emotivo', 'Calmo e ponderado', 'Divertido e descontraído'],
    },
    {
      'question': 'Como você lida com conflitos?',
      'options': ['Converso abertamente', 'Preciso de tempo para pensar', 'Busco compromisso', 'Evito confrontos'],
    },
  ];

  void _handleAnswer(int optionIndex) {
    setState(() {
      _answers[_currentQuestion] = optionIndex;

      if (_currentQuestion < _questions.length - 1) {
        _currentQuestion++;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completo!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            const Text('Suas respostas ajudarão a encontrar matches mais compatíveis!', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (_currentQuestion + 1) / _questions.length;
    final question = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz de Compatibilidade')),
      body: Column(
        children: [
          // Progress
          LinearProgressIndicator(value: progress, backgroundColor: theme.colorScheme.surfaceContainerHighest),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Número da questão
                  Text(
                    'Pergunta ${_currentQuestion + 1} de ${_questions.length}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pergunta
                  Text(
                    question['question'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 32),

                  // Opções
                  Expanded(
                    child: ListView.builder(
                      itemCount: (question['options'] as List).length,
                      itemBuilder: (context, index) {
                        final option = (question['options'] as List)[index];
                        final isSelected = _answers[_currentQuestion] == index;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: isSelected ? 4 : 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isSelected
                                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                                  : BorderSide.none,
                            ),
                            child: InkWell(
                              onTap: () => _handleAnswer(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                                          width: 2,
                                        ),
                                        color: isSelected ? theme.colorScheme.primary : null,
                                      ),
                                      child: isSelected
                                          ? Icon(Icons.check, size: 16, color: theme.colorScheme.onPrimary)
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        option as String,
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão Voltar
          if (_currentQuestion > 0)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SecondaryButton(text: 'Voltar', onPressed: () => setState(() => _currentQuestion--)),
            ),
        ],
      ),
    );
  }
}
