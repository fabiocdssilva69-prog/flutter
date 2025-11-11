import 'package:dart_mappable/dart_mappable.dart';

part 'smart_reminder.mapper.dart';

/// Entidade para lembretes inteligentes (Phase 2)
@MappableClass()
class SmartReminder with SmartReminderMappable {
  /// ID do lembrete
  final String reminderId;
  
  /// ID do usuário
  final String userId;
  
  /// Tipo de lembrete
  final ReminderType type;
  
  /// Título do lembrete
  final String title;
  
  /// Mensagem detalhada
  final String message;
  
  /// Quando notificar
  final DateTime scheduledFor;
  
  /// Contexto relacionado (matchId, messageId, etc)
  final Map<String, dynamic>? context;
  
  /// Se foi enviado
  final bool wasSent;
  
  /// Se o usuário já agiu (abriu, respondeu, etc)
  final bool wasActedUpon;
  
  /// Prioridade (1-5)
  final int priority;
  
  /// Timestamp de criação
  final DateTime createdAt;
  
  const SmartReminder({
    required this.reminderId,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.scheduledFor,
    this.context,
    this.wasSent = false,
    this.wasActedUpon = false,
    this.priority = 3,
    required this.createdAt,
  });
  
  /// Converter para Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.name,
      'title': title,
      'message': message,
      'scheduledFor': scheduledFor.millisecondsSinceEpoch,
      'context': context,
      'wasSent': wasSent,
      'wasActedUpon': wasActedUpon,
      'priority': priority,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
  
  /// Verificar se deve ser enviado agora
  bool shouldSendNow() {
    return !wasSent && DateTime.now().isAfter(scheduledFor);
  }
}

/// Tipos de lembretes inteligentes
enum ReminderType {
  /// Lembrar de responder mensagem
  replyToMessage,
  
  /// Lembrar de iniciar conversa com match
  startConversation,
  
  /// Match prestes a expirar (72h)
  matchExpiringSoon,
  
  /// Perfil inativo há dias
  profileInactive,
  
  /// Sugestão de atualizar fotos
  updatePhotos,
  
  /// Completar prompts
  completePrompts,
  
  /// Revisar matches pendentes
  reviewMatches,
  
  /// Horário de pico de atividade
  peakActivityTime,
  
  /// Boost disponível
  boostAvailable,
  
  /// Super like renovado
  superLikeRenewed,
}

/// Configuração de preferências de lembretes
@MappableClass()
class ReminderPreferences with ReminderPreferencesMappable {
  /// Tipos de lembretes habilitados
  final Set<ReminderType> enabledTypes;
  
  /// Horário de início das notificações
  final int startHour; // 0-23
  
  /// Horário de fim das notificações
  final int endHour; // 0-23
  
  /// Dias da semana habilitados (0=domingo, 6=sábado)
  final Set<int> enabledDays;
  
  /// Frequência máxima (notificações por dia)
  final int maxPerDay;
  
  const ReminderPreferences({
    this.enabledTypes = const {
      ReminderType.replyToMessage,
      ReminderType.matchExpiringSoon,
      ReminderType.superLikeRenewed,
    },
    this.startHour = 9,
    this.endHour = 22,
    this.enabledDays = const {1, 2, 3, 4, 5, 6, 0}, // Todos os dias
    this.maxPerDay = 5,
  });
  
  /// Verificar se pode notificar agora
  bool canNotifyNow() {
    final now = DateTime.now();
    
    // Verificar horário
    if (now.hour < startHour || now.hour >= endHour) return false;
    
    // Verificar dia da semana
    if (!enabledDays.contains(now.weekday % 7)) return false;
    
    return true;
  }
}
