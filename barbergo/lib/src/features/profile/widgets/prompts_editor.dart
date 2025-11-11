import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/prompt_response.dart';
import '../controllers/prompts_controller.dart';

/// Widget para editar prompts do perfil (3 obrigatórios)
class PromptsEditor extends ConsumerStatefulWidget {
  final List<PromptResponse> initialPrompts;
  final ValueChanged<List<PromptResponse>> onPromptsChanged;

  const PromptsEditor({super.key, required this.initialPrompts, required this.onPromptsChanged});

  @override
  ConsumerState<PromptsEditor> createState() => _PromptsEditorState();
}

class _PromptsEditorState extends ConsumerState<PromptsEditor> {
  late List<PromptResponse?> _prompts;
  final List<TextEditingController> _controllers = [];
  final List<PromptDefinition?> _selectedPrompts = [null, null, null];

  @override
  void initState() {
    super.initState();
    _prompts = List.filled(3, null);

    // Inicializar com prompts existentes
    for (var i = 0; i < widget.initialPrompts.length && i < 3; i++) {
      _prompts[i] = widget.initialPrompts[i];
      _controllers.add(TextEditingController(text: widget.initialPrompts[i].response));

      // Buscar prompt definition
      final promptDef = ref.read(promptsControllerProvider.notifier).getPromptById(widget.initialPrompts[i].promptId);
      _selectedPrompts[i] = promptDef;
    }

    // Completar com controllers vazios
    while (_controllers.length < 3) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _selectPrompt(int index) async {
    final controller = ref.read(promptsControllerProvider.notifier);
    final availablePrompts = controller.getAvailablePrompts();

    // Filtrar prompts já selecionados
    final usedPromptIds = _selectedPrompts.whereType<PromptDefinition>().map((p) => p.id).toSet();

    final filteredPrompts = availablePrompts.where((p) => !usedPromptIds.contains(p.id)).toList();

    // Agrupar por categoria
    final categories = controller.getCategories();

    final selected = await showModalBottomSheet<PromptDefinition>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Escolha um Prompt', style: Theme.of(context).textTheme.titleLarge),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: categories.length,
                itemBuilder: (context, catIndex) {
                  final category = categories[catIndex];
                  final categoryPrompts = filteredPrompts.where((p) => p.category == category).toList();

                  if (categoryPrompts.isEmpty) return const SizedBox.shrink();

                  return ExpansionTile(
                    title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                    initiallyExpanded: catIndex == 0,
                    children: categoryPrompts.map((prompt) {
                      return ListTile(title: Text(prompt.text), onTap: () => Navigator.pop(context, prompt));
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedPrompts[index] = selected;
        _controllers[index].clear(); // Limpar resposta anterior
      });
    }
  }

  void _updatePrompts() {
    final controller = ref.read(promptsControllerProvider.notifier);
    final validPrompts = <PromptResponse>[];

    for (var i = 0; i < 3; i++) {
      final promptDef = _selectedPrompts[i];
      final response = _controllers[i].text.trim();

      if (promptDef != null && response.isNotEmpty && response.length >= 20) {
        try {
          final promptResponse = controller.createPromptResponse(
            promptId: promptDef.id,
            promptText: promptDef.text,
            response: response,
          );
          validPrompts.add(promptResponse);
        } catch (e) {
          // Ignorar prompts inválidos
        }
      }
    }

    widget.onPromptsChanged(validPrompts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mostre sua Personalidade', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'Escolha 3 prompts e responda (mínimo 20 caracteres cada)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),

        // 3 Prompt Cards
        ...List.generate(3, (index) {
          final promptDef = _selectedPrompts[index];
          final controller = _controllers[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botão para selecionar prompt
                  OutlinedButton.icon(
                    onPressed: () => _selectPrompt(index),
                    icon: Icon(promptDef == null ? Icons.add : Icons.edit),
                    label: Text(promptDef?.text ?? 'Escolher Prompt ${index + 1}'),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  ),

                  // Campo de resposta
                  if (promptDef != null) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: InputDecoration(
                        hintText: 'Sua resposta...',
                        border: const OutlineInputBorder(),
                        helperText: controller.text.length < 20 ? 'Mínimo 20 caracteres' : null,
                      ),
                      onChanged: (_) {
                        setState(() {});
                        _updatePrompts();
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        }),

        // Preview dos prompts
        if (_prompts.where((p) => p != null).isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Preview do Card', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _prompts.whereType<PromptResponse>().map((prompt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prompt.promptText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(prompt.response, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
