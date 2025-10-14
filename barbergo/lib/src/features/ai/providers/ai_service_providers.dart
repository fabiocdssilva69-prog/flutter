// Este arquivo agora é apenas um re-export dos providers já existentes
// AIService e ClaudeService já são definidos como @riverpod class em seus respectivos arquivos
//
// Para usar:
// - ref.read(aIServiceProvider) ou ref.watch(aIServiceProvider)
// - ref.read(claudeServiceProvider) ou ref.watch(claudeServiceProvider)
//
// Não é necessário criar providers adicionais aqui, pois riverpod_generator
// já cria os providers automaticamente para classes anotadas com @riverpod

export 'ai_service.dart';
export 'claude_service.dart';
