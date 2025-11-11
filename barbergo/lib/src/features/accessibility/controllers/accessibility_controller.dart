import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter_tts/flutter_tts.dart';

part 'accessibility_controller.g.dart';

enum AccessibilityMode { normal, highContrast, largeText, voiceControl }

class AccessibilitySettings {
  final AccessibilityMode mode;
  final double textScale;
  final bool voiceControlEnabled;
  final bool screenReaderEnabled;
  final bool reducedMotion;
  final bool hapticFeedback;
  final String voiceLanguage;

  AccessibilitySettings({
    this.mode = AccessibilityMode.normal,
    this.textScale = 1.0,
    this.voiceControlEnabled = false,
    this.screenReaderEnabled = false,
    this.reducedMotion = false,
    this.hapticFeedback = true,
    this.voiceLanguage = 'pt-BR',
  });

  AccessibilitySettings copyWith({
    AccessibilityMode? mode,
    double? textScale,
    bool? voiceControlEnabled,
    bool? screenReaderEnabled,
    bool? reducedMotion,
    bool? hapticFeedback,
    String? voiceLanguage,
  }) {
    return AccessibilitySettings(
      mode: mode ?? this.mode,
      textScale: textScale ?? this.textScale,
      voiceControlEnabled: voiceControlEnabled ?? this.voiceControlEnabled,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      voiceLanguage: voiceLanguage ?? this.voiceLanguage,
    );
  }

  ThemeData getTheme() {
    switch (mode) {
      case AccessibilityMode.highContrast:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.yellow,
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      case AccessibilityMode.largeText:
        return ThemeData(
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 18 * textScale),
            bodyMedium: TextStyle(fontSize: 16 * textScale),
            titleLarge: TextStyle(fontSize: 24 * textScale, fontWeight: FontWeight.bold),
          ),
        );
      default:
        return ThemeData.light();
    }
  }
}

@riverpod
class AccessibilityController extends _$AccessibilityController {
  // NOTA: Speech-to-Text e TTS comentados temporariamente devido a problemas de compatibilidade Android
  // late stt.SpeechToText _speech;
  // late FlutterTts _tts;

  @override
  AccessibilitySettings build() {
    // _speech = stt.SpeechToText();
    // _tts = FlutterTts();
    // _initializeTTS();
    return AccessibilitySettings();
  }

  // void _initializeTTS() {
  //   _tts.setLanguage('pt-BR');
  //   _tts.setSpeechRate(0.5);
  //   _tts.setVolume(1.0);
  //   _tts.setPitch(1.0);
  // }

  void setMode(AccessibilityMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setTextScale(double scale) {
    state = state.copyWith(textScale: scale);
  }

  void toggleVoiceControl() {
    state = state.copyWith(voiceControlEnabled: !state.voiceControlEnabled);
    // TODO: Implementar quando speech_to_text for compatível
    // if (state.voiceControlEnabled) {
    //   _initializeSpeechRecognition();
    // }
  }

  void toggleScreenReader() {
    state = state.copyWith(screenReaderEnabled: !state.screenReaderEnabled);
  }

  void toggleReducedMotion() {
    state = state.copyWith(reducedMotion: !state.reducedMotion);
  }

  void toggleHapticFeedback() {
    state = state.copyWith(hapticFeedback: !state.hapticFeedback);
  }

  void setVoiceLanguage(String language) {
    state = state.copyWith(voiceLanguage: language);
    // _tts.setLanguage(language);
  }

  // Text-to-Speech (placeholder)
  Future<void> speak(String text) async {
    if (state.screenReaderEnabled) {
      // TODO: Implementar TTS quando flutter_tts for compatível
      print('[TTS] Would speak: $text');
    }
  }

  Future<void> stopSpeaking() async {
    // await _tts.stop();
    print('[TTS] Stopped speaking');
  }

  // Speech-to-Text (placeholder)
  Future<void> _initializeSpeechRecognition() async {
    // await _speech.initialize(
    //   onStatus: (status) => print('Speech status: $status'),
    //   onError: (error) => print('Speech error: $error'),
    // );
    print('[STT] Would initialize speech recognition');
  }

  Future<String?> startListening() async {
    if (!state.voiceControlEnabled) return null;

    // TODO: Implementar quando speech_to_text for compatível
    print('[STT] Would start listening');
    return 'Comando de voz simulado'; // Placeholder para testes
    
    // String recognizedText = '';
    // await _speech.listen(
    //   onResult: (result) {
    //     recognizedText = result.recognizedWords;
    //   },
    //   localeId: state.voiceLanguage,
    // );
    //
    // // Wait for recognition
    // await Future.delayed(const Duration(seconds: 3));
    // await _speech.stop();
    //
    // return recognizedText.isNotEmpty ? recognizedText : null;
  }

  // Voice Commands Processing
  Future<void> processVoiceCommand(String command) async {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('abrir') || lowerCommand.contains('open')) {
      if (lowerCommand.contains('perfil') || lowerCommand.contains('profile')) {
        await speak('Abrindo perfil');
        // Navigate to profile
      } else if (lowerCommand.contains('agendamento') || lowerCommand.contains('booking')) {
        await speak('Abrindo agendamentos');
        // Navigate to bookings
      }
    } else if (lowerCommand.contains('buscar') || lowerCommand.contains('search')) {
      await speak('O que você deseja buscar?');
      // Open search
    } else if (lowerCommand.contains('ajuda') || lowerCommand.contains('help')) {
      await speak('Como posso ajudar você?');
      // Show help
    }
  }
}

// Language support provider
@riverpod
List<Map<String, String>> supportedAccessibilityLanguages(Ref ref) {
  return [
    {'code': 'pt-BR', 'name': 'Português (Brasil)', 'flag': '🇧🇷'},
    {'code': 'en-US', 'name': 'English (US)', 'flag': '🇺🇸'},
    {'code': 'es-ES', 'name': 'Español (España)', 'flag': '🇪🇸'},
    {'code': 'fr-FR', 'name': 'Français (France)', 'flag': '🇫🇷'},
    {'code': 'de-DE', 'name': 'Deutsch (Deutschland)', 'flag': '🇩🇪'},
    {'code': 'it-IT', 'name': 'Italiano (Italia)', 'flag': '🇮🇹'},
    {'code': 'ja-JP', 'name': '日本語 (日本)', 'flag': '🇯🇵'},
    {'code': 'zh-CN', 'name': '中文 (中国)', 'flag': '🇨🇳'},
    {'code': 'ko-KR', 'name': '한국어 (한국)', 'flag': '🇰🇷'},
    {'code': 'ar-SA', 'name': 'العربية (السعودية)', 'flag': '🇸🇦'},
    {'code': 'hi-IN', 'name': 'हिन्दी (भारत)', 'flag': '🇮🇳'},
    {'code': 'ru-RU', 'name': 'Русский (Россия)', 'flag': '🇷🇺'},
    {'code': 'tr-TR', 'name': 'Türkçe (Türkiye)', 'flag': '🇹🇷'},
    {'code': 'nl-NL', 'name': 'Nederlands (Nederland)', 'flag': '🇳🇱'},
    {'code': 'sv-SE', 'name': 'Svenska (Sverige)', 'flag': '🇸🇪'},
  ];
}
