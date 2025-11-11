import 'package:firebase_messaging/firebase_messaging.dart';

/// Script simples para obter o FCM Token
/// 
/// Como usar:
/// 1. Certifique-se que o app está rodando no dispositivo
/// 2. Este método será chamado automaticamente no main.dart
Future<void> printFcmToken() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    
    if (token != null) {
      print('\n');
      print('=' * 80);
      print('🔑 FCM TOKEN (copie abaixo):');
      print('=' * 80);
      print(token);
      print('=' * 80);
      print('\n');
      print('📋 Passos para testar notificação:');
      print('1. Copie o token acima');
      print('2. Acesse: https://console.firebase.google.com/project/barbergo-38c21/notification');
      print('3. Clique em "New notification"');
      print('4. Clique em "Send test message"');
      print('5. Cole o token e envie!');
      print('=' * 80);
      print('\n');
    } else {
      print('❌ Erro: Não foi possível obter o FCM Token');
    }
  } catch (e) {
    print('❌ Erro ao obter FCM Token: $e');
  }
}
