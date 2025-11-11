import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/video_call_controller.dart';

class VideoCallScreen extends ConsumerWidget {
  final String receiverId;
  final String receiverName;

  const VideoCallScreen({super.key, required this.receiverId, required this.receiverName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Chamada com $receiverName')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam, size: 100, color: Colors.green),
            const SizedBox(height: 32),
            Text(receiverName, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () async {
                await ref
                    .read(videoCallControllerProvider.notifier)
                    .initiateCall(
                      callerId: 'current-user',
                      receiverId: receiverId,
                      callerName: 'Você',
                      receiverName: receiverName,
                    );
              },
              icon: const Icon(Icons.call),
              label: const Text('Iniciar Chamada'),
            ),
            const SizedBox(height: 16),
            const Text('🎥 Funcionalidade em desenvolvimento', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('Integração com WebRTC em breve', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
