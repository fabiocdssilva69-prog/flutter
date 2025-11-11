import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/ai_message_entity.dart';

class AiMessageBubble extends StatelessWidget {
  final AiMessageEntity message;
  final bool showAvatar;

  const AiMessageBubble({super.key, required this.message, this.showAvatar = true});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUserMessage;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Avatar (IA only)
          if (!isUser && showAvatar)
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),

          if (!isUser && !showAvatar) const SizedBox(width: 44),

          // Message bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Image (if exists)
                if (message.imageUrl != null) ...[
                  ClipRRectangular(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: message.imageUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) =>
                          Container(width: 200, height: 200, color: Colors.grey[200], child: const Icon(Icons.error)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Text bubble
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.purple : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                  ),
                  child: isUser
                      ? Text(message.content, style: const TextStyle(color: Colors.white, fontSize: 15))
                      : MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(color: Colors.black87, fontSize: 15),
                            strong: const TextStyle(fontWeight: FontWeight.bold),
                            h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            listBullet: const TextStyle(fontSize: 15),
                          ),
                        ),
                ),

                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Text(_formatTime(message.timestamp), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ),
              ],
            ),
          ),

          // Avatar (user only)
          if (isUser && showAvatar)
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              child: const Icon(Icons.person, color: Colors.grey, size: 20),
            ),

          if (isUser && !showAvatar) const SizedBox(width: 44),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Agora';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}min';
    } else if (diff.inDays < 1) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      final days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      return '${days[time.weekday % 7]} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}

class ClipRRectangular extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;

  const ClipRRectangular({super.key, required this.child, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: borderRadius, child: child);
  }
}
