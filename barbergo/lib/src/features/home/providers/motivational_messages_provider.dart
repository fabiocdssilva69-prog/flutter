import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/motivational_message.dart';

part 'motivational_messages_provider.g.dart';

/// Provider para mensagens motivacionais do Firebase (sem repetir a última)
@riverpod
class MotivationalMessagesProvider extends _$MotivationalMessagesProvider {
  @override
  Future<MotivationalMessage> build() async {
    return _fetchRandomMessage();
  }

  /// Busca mensagens do Firestore e sorteia uma aleatória (evita repetir a última)
  Future<MotivationalMessage> _fetchRandomMessage() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final prefs = await SharedPreferences.getInstance();
      final lastMessageId = prefs.getString('last_message_id');

      // Buscar mensagens ativas
      final snapshot = await firestore.collection('motivational_messages').where('isActive', isEqualTo: true).get();

      if (snapshot.docs.isEmpty) {
        print('⚠️ AVISO: Nenhuma mensagem ativa encontrada no Firebase!');
        // Usar mensagens fallback
        return _getRandomFallback(lastMessageId);
      }

      // Log para verificar o pool completo de mensagens
      print('✅ Total de mensagens ATIVAS no Firebase: ${snapshot.docs.length}');

      // Converter e filtrar apenas mensagens COM autor
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();
        return MotivationalMessage(
          messageId: doc.id,
          message: data['message'] as String? ?? '',
          authorName: data['authorName'] as String?,
          authorRole: data['authorRole'] as String?,
          category: data['category'] as String? ?? 'motivation',
          emoji: data['emoji'] as String? ?? '💡',
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          isActive: data['isActive'] as bool? ?? true,
        );
      }).where((m) => m.authorName != null && m.authorName!.isNotEmpty).toList();

      print('📝 Mensagens com autor: ${messages.length}');
      if (messages.isEmpty) return _getRandomFallback(lastMessageId);

      // Filtrar mensagens que não sejam a última mostrada
      final availableMessages = messages.where((m) => m.messageId != lastMessageId).toList();

      print('🎲 Mensagens disponíveis: ${availableMessages.length}');

      if (availableMessages.isEmpty) {
        // Reset do pool — pega de mensagens com autor
        print('🔄 Pool resetado');
        final random = Random();
        final selectedMessage = messages[random.nextInt(messages.length)];
        print(
          '🎯 Mensagem selecionada: "${selectedMessage.message.substring(0, selectedMessage.message.length > 50 ? 50 : selectedMessage.message.length)}..." (ID: ${selectedMessage.messageId})',
        );
        await _saveCurrentMessage(selectedMessage);
        return selectedMessage;
      }

      // Sortear mensagem aleatória das disponíveis
      final random = Random();
      final selectedMessage = availableMessages[random.nextInt(availableMessages.length)];
      print(
        '🎯 Mensagem selecionada: "${selectedMessage.message.substring(0, selectedMessage.message.length > 50 ? 50 : selectedMessage.message.length)}..." (ID: ${selectedMessage.messageId})',
      );
      await _saveCurrentMessage(selectedMessage);
      return selectedMessage;
    } catch (e) {
      print('❌ Erro ao buscar mensagens: $e');
      // Em caso de erro, usar fallback
      final prefs = await SharedPreferences.getInstance();
      final lastMessageId = prefs.getString('last_message_id');
      return _getRandomFallback(lastMessageId);
    }
  }

  /// Salva a mensagem atual para sincronização com o card da home
  Future<void> _saveCurrentMessage(MotivationalMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    // Guarda o ID anterior antes de sobrescrever
    final currentId = prefs.getString('current_message_id');
    if (currentId != null) {
      await prefs.setString('last_message_id', currentId); // para filtro anti-repetição
    }
    await prefs.setString('current_message_id', message.messageId);
    await prefs.setString('current_message_text', message.message);
    await prefs.setString('current_message_author', message.authorName ?? '');
    await prefs.setString('current_message_emoji', message.emoji);
    await prefs.setString('current_message_category', message.category);
  }

  /// Busca a mensagem atual salva (para usar no card da home)
  Future<MotivationalMessage?> getCurrentSavedMessage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messageId = prefs.getString('current_message_id');
      final messageText = prefs.getString('current_message_text');
      final author = prefs.getString('current_message_author');
      final emoji = prefs.getString('current_message_emoji');
      final category = prefs.getString('current_message_category');

      if (messageId == null || messageText == null) return null;

      return MotivationalMessage(
        messageId: messageId,
        message: messageText,
        authorName: author?.isNotEmpty == true ? author : null,
        category: category ?? 'motivation',
        emoji: emoji ?? '💡',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Sorteia uma mensagem fallback (evita repetir)
  Future<MotivationalMessage> _getRandomFallback(String? lastMessageId) async {
    final random = Random();
    final fallbacks = MotivationalMessage.fallbackMessages
        .where((m) => m.authorName != null && m.authorName!.isNotEmpty)
        .toList();

    // Filtrar mensagens que não sejam a última
    final available = fallbacks.where((m) => m.messageId != lastMessageId).toList();

    final selectedMessage = available.isEmpty
        ? fallbacks[random.nextInt(fallbacks.length)]
        : available[random.nextInt(available.length)];

    await _saveCurrentMessage(selectedMessage);
    return selectedMessage;
  }

  /// Força reload da mensagem
  Future<void> refreshMessage() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRandomMessage());
  }
}
