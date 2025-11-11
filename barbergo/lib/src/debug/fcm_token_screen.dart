import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tela de debug para obter o FCM Token
///
/// Para usar, adicione na navegação:
/// Navigator.push(context, MaterialPageRoute(builder: (_) => FcmTokenScreen()))
class FcmTokenScreen extends StatefulWidget {
  const FcmTokenScreen({super.key});

  @override
  State<FcmTokenScreen> createState() => _FcmTokenScreenState();
}

class _FcmTokenScreenState extends State<FcmTokenScreen> {
  String? _fcmToken;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getFcmToken();
  }

  Future<void> _getFcmToken() async {
    try {
      // Obtém o token FCM
      final token = await FirebaseMessaging.instance.getToken();

      setState(() {
        _fcmToken = token;
        _loading = false;
      });

      // Também imprime no console para facilitar
      print('🔑 FCM Token: $token');
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('❌ Erro ao obter FCM Token: $e');
    }
  }

  void _copyToClipboard() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Token copiado para a área de transferência!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔑 FCM Token'), backgroundColor: Colors.orange),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ícone
                  const Icon(Icons.vpn_key, size: 80, color: Colors.orange),
                  const SizedBox(height: 24),

                  // Título
                  const Text(
                    'Firebase Cloud Messaging Token',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Token
                  if (_fcmToken != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: SelectableText(_fcmToken!, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
                    ),
                    const SizedBox(height: 24),

                    // Botão copiar
                    ElevatedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text('Copiar Token'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Instruções
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.blue.shade700),
                                const SizedBox(width: 8),
                                const Text('Como usar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '1. Copie o token acima\n'
                              '2. Acesse: Firebase Console → Cloud Messaging\n'
                              '3. Clique em "New notification"\n'
                              '4. Clique em "Send test message"\n'
                              '5. Cole o token e envie!',
                              style: TextStyle(fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    const Text(
                      '❌ Não foi possível obter o FCM Token.\n'
                      'Verifique se o Firebase está configurado corretamente.',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
    );
  }
}
