import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/accessibility_controller.dart';

class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(accessibilityControllerProvider);
    final controller = ref.read(accessibilityControllerProvider.notifier);
    final languages = ref.watch(supportedAccessibilityLanguagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Acessibilidade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: settings.voiceControlEnabled ? () => _startVoiceCommand(context, controller) : null,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Modo de Exibição', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _AccessibilityModeTile(
            title: 'Normal',
            subtitle: 'Tema padrão do aplicativo',
            icon: Icons.brightness_medium,
            isSelected: settings.mode == AccessibilityMode.normal,
            onTap: () => controller.setMode(AccessibilityMode.normal),
          ),
          _AccessibilityModeTile(
            title: 'Alto Contraste',
            subtitle: 'Fundo escuro com texto amarelo',
            icon: Icons.contrast,
            isSelected: settings.mode == AccessibilityMode.highContrast,
            onTap: () => controller.setMode(AccessibilityMode.highContrast),
          ),
          _AccessibilityModeTile(
            title: 'Texto Grande',
            subtitle: 'Aumenta o tamanho dos textos',
            icon: Icons.text_fields,
            isSelected: settings.mode == AccessibilityMode.largeText,
            onTap: () => controller.setMode(AccessibilityMode.largeText),
          ),
          const SizedBox(height: 24),
          const Text('Tamanho do Texto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('A', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: settings.textScale,
                          min: 0.8,
                          max: 2.0,
                          divisions: 12,
                          label: '${(settings.textScale * 100).toInt()}%',
                          onChanged: (value) => controller.setTextScale(value),
                        ),
                      ),
                      const Text('A', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  Text(
                    'Exemplo de texto',
                    style: TextStyle(fontSize: 16 * settings.textScale),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Recursos de Voz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Controle por Voz'),
            subtitle: const Text('Use comandos de voz para navegar'),
            secondary: const Icon(Icons.record_voice_over),
            value: settings.voiceControlEnabled,
            onChanged: (_) => controller.toggleVoiceControl(),
          ),
          SwitchListTile(
            title: const Text('Leitor de Tela'),
            subtitle: const Text('Lê em voz alta os elementos da tela'),
            secondary: const Icon(Icons.hearing),
            value: settings.screenReaderEnabled,
            onChanged: (_) => controller.toggleScreenReader(),
          ),
          if (settings.voiceControlEnabled || settings.screenReaderEnabled) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Idioma da Voz', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: settings.voiceLanguage,
                      items: languages.map((lang) {
                        return DropdownMenuItem(
                          value: lang['code'],
                          child: Row(
                            children: [
                              Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Text(lang['name']!),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) controller.setVoiceLanguage(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text('Outras Opções', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Reduzir Movimento'),
            subtitle: const Text('Minimiza animações'),
            secondary: const Icon(Icons.animation),
            value: settings.reducedMotion,
            onChanged: (_) => controller.toggleReducedMotion(),
          ),
          SwitchListTile(
            title: const Text('Feedback Tátil'),
            subtitle: const Text('Vibração ao tocar'),
            secondary: const Icon(Icons.vibration),
            value: settings.hapticFeedback,
            onChanged: (_) => controller.toggleHapticFeedback(),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.blue.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Comandos de Voz Disponíveis', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text('• "Abrir perfil"'),
                  Text('• "Abrir agendamentos"'),
                  Text('• "Buscar barbeiro"'),
                  Text('• "Ajuda"'),
                  Text('• "Voltar"'),
                  SizedBox(height: 8),
                  Text('Mais comandos em breve!', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.purple.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.sign_language, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('LIBRAS', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Suporte a LIBRAS em desenvolvimento'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Open LIBRAS interpreter
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Intérprete de LIBRAS em breve!')),
                      );
                    },
                    icon: const Icon(Icons.video_call),
                    label: const Text('Videochamada com Intérprete'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: settings.voiceControlEnabled
          ? FloatingActionButton.extended(
              onPressed: () => _startVoiceCommand(context, controller),
              icon: const Icon(Icons.mic),
              label: const Text('Comando de Voz'),
            )
          : null,
    );
  }

  Future<void> _startVoiceCommand(BuildContext context, AccessibilityController controller) async {
    await controller.speak('Estou ouvindo');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Escutando...', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Diga seu comando', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );

    final command = await controller.startListening();
    Navigator.pop(context);

    if (command != null && command.isNotEmpty) {
      await controller.processVoiceCommand(command);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comando: $command')),
      );
    } else {
      await controller.speak('Não entendi o comando');
    }
  }
}

class _AccessibilityModeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccessibilityModeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
        title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        subtitle: Text(subtitle),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
        onTap: onTap,
      ),
    );
  }
}
