import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'match_timer.mapper.dart';

/// Entidade para rastreamento de timers de matches (Phase 1 - Anti-Ghosting)
/// 
/// Todo match tem 72h para iniciar conversa, senão é deletado automaticamente.
@MappableClass()
class MatchTimer with MatchTimerMappable {
  /// ID do timer (gerado pelo Firestore)
  final String timerId;

  /// ID do match associado
  final String matchId;

  /// IDs dos dois usuários
  final String user1Id;
  final String user2Id;

  /// Timestamp de quando o match foi criado
  final DateTime matchCreatedAt;

  /// Timestamp de quando o timer expira (matchCreatedAt + 72h)
  final DateTime expiresAt;

  /// Status do timer
  final TimerStatus status;

  /// Timestamp da primeira mensagem (se houver)
  final DateTime? firstMessageAt;

  /// Timestamp da última notificação enviada
  final DateTime? lastNotificationAt;

  const MatchTimer({
    required this.timerId,
    required this.matchId,
    required this.user1Id,
    required this.user2Id,
    required this.matchCreatedAt,
    required this.expiresAt,
    required this.status,
    this.firstMessageAt,
    this.lastNotificationAt,
  });

  /// Converter para Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'matchId': matchId,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'matchCreatedAt': Timestamp.fromDate(matchCreatedAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'status': status.name,
      'firstMessageAt': firstMessageAt != null ? Timestamp.fromDate(firstMessageAt!) : null,
      'lastNotificationAt': lastNotificationAt != null ? Timestamp.fromDate(lastNotificationAt!) : null,
    };
  }

  /// Criar a partir de Map do Firestore
  factory MatchTimer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchTimer(
      timerId: doc.id,
      matchId: data['matchId'] as String,
      user1Id: data['user1Id'] as String,
      user2Id: data['user2Id'] as String,
      matchCreatedAt: (data['matchCreatedAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      status: TimerStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => TimerStatus.active,
      ),
      firstMessageAt: data['firstMessageAt'] != null 
          ? (data['firstMessageAt'] as Timestamp).toDate() 
          : null,
      lastNotificationAt: data['lastNotificationAt'] != null 
          ? (data['lastNotificationAt'] as Timestamp).toDate() 
          : null,
    );
  }

  /// Criar novo timer para match
  factory MatchTimer.forMatch({
    required String matchId,
    required String user1Id,
    required String user2Id,
  }) {
    final now = DateTime.now();
    return MatchTimer(
      timerId: '',
      matchId: matchId,
      user1Id: user1Id,
      user2Id: user2Id,
      matchCreatedAt: now,
      expiresAt: now.add(const Duration(hours: 72)),
      status: TimerStatus.active,
    );
  }

  /// Verificar se o timer expirou
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Tempo restante em horas
  int get hoursRemaining {
    if (isExpired) return 0;
    final diff = expiresAt.difference(DateTime.now());
    return diff.inHours;
  }

  /// Verificar se deve enviar notificação
  bool shouldSendNotification() {
    if (status != TimerStatus.active) return false;
    if (firstMessageAt != null) return false; // Já conversaram
    
    final remaining = hoursRemaining;
    
    // Enviar em 48h, 24h e 6h restantes
    if (remaining <= 6 || remaining <= 24 || remaining <= 48) {
      // Se já enviou notificação, verificar se passou tempo suficiente
      if (lastNotificationAt != null) {
        final hoursSinceLastNotif = DateTime.now().difference(lastNotificationAt!).inHours;
        return hoursSinceLastNotif >= 6; // Esperar 6h entre notificações
      }
      return true;
    }
    
    return false;
  }

  /// Texto para exibição do timer
  String getTimerText() {
    if (isExpired) return 'Expirado';
    
    final remaining = hoursRemaining;
    if (remaining >= 24) {
      final days = (remaining / 24).floor();
      return '$days ${days == 1 ? 'dia' : 'dias'}';
    } else {
      return '$remaining ${remaining == 1 ? 'hora' : 'horas'}';
    }
  }
}

/// Status do timer
enum TimerStatus {
  /// Timer ativo, aguardando primeira mensagem
  active,
  
  /// Timer pausado porque houve mensagem
  paused,
  
  /// Timer expirado, match será deletado
  expired,
  
  /// Timer cancelado manualmente
  cancelled,
}
