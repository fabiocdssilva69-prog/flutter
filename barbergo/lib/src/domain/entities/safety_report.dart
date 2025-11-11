import 'package:dart_mappable/dart_mappable.dart';

part 'safety_report.g.dart';

/// Entity para Safety Center (Phase 3)
/// Sistema de segurança, relatórios e bloqueios
@MappableClass()
class SafetyReport with SafetyReportMappable {
  final String reportId;
  final String reporterId;
  final String reportedUserId;
  final ReportReason reason;
  final String? customReason;
  final List<String> evidenceUrls; // Screenshots, conversas
  final DateTime createdAt;
  final ReportStatus status;
  final String? reviewedBy; // Admin ID
  final DateTime? reviewedAt;
  final ReportAction? action;
  final String? reviewNotes;
  final ReportSeverity severity;

  const SafetyReport({
    required this.reportId,
    required this.reporterId,
    required this.reportedUserId,
    required this.reason,
    this.customReason,
    this.evidenceUrls = const [],
    required this.createdAt,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.action,
    this.reviewNotes,
    this.severity = ReportSeverity.medium,
  });

  SafetyReport copyWith({
    ReportStatus? status,
    String? reviewedBy,
    DateTime? reviewedAt,
    ReportAction? action,
    String? reviewNotes,
    ReportSeverity? severity,
  }) {
    return SafetyReport(
      reportId: reportId,
      reporterId: reporterId,
      reportedUserId: reportedUserId,
      reason: reason,
      customReason: customReason,
      evidenceUrls: evidenceUrls,
      createdAt: createdAt,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      action: action ?? this.action,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      severity: severity ?? this.severity,
    );
  }
}

/// Razões de denúncia
enum ReportReason {
  inappropriatePhotos,
  harassment,
  hateSpeech,
  violence,
  spam,
  scam,
  fakeProfile,
  underage,
  inappropriateContent,
  stalking,
  threatPhysicalHarm,
  sexualContent,
  impersonation,
  other,
}

/// Status do relatório
enum ReportStatus {
  pending, // Aguardando análise
  underReview, // Em análise
  resolved, // Resolvido
  dismissed, // Arquivado (sem ação)
  escalated, // Escalado para revisão superior
}

/// Ação tomada
enum ReportAction {
  noAction, // Nenhuma ação
  warning, // Aviso ao usuário
  temporarySuspension, // Suspensão temporária (7/30 dias)
  permanentBan, // Ban permanente
  contentRemoved, // Conteúdo removido
  accountReview, // Conta em revisão
}

/// Severidade do relatório
enum ReportSeverity {
  low, // Baixa prioridade
  medium, // Prioridade média
  high, // Alta prioridade
  critical, // Emergência (ameaça física)
}

/// Bloqueio de usuário
@MappableClass()
class UserBlock with UserBlockMappable {
  final String blockId;
  final String blockerId;
  final String blockedUserId;
  final DateTime blockedAt;
  final String? reason;

  const UserBlock({
    required this.blockId,
    required this.blockerId,
    required this.blockedUserId,
    required this.blockedAt,
    this.reason,
  });
}

/// Contato de emergência
@MappableClass()
class EmergencyContact with EmergencyContactMappable {
  final String contactId;
  final String userId;
  final String name;
  final String phoneNumber;
  final String? email;
  final bool isEnabled;
  final DateTime addedAt;
  final DateTime? lastNotifiedAt;

  const EmergencyContact({
    required this.contactId,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.isEnabled = true,
    required this.addedAt,
    this.lastNotifiedAt,
  });

  EmergencyContact copyWith({bool? isEnabled, DateTime? lastNotifiedAt}) {
    return EmergencyContact(
      contactId: contactId,
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      isEnabled: isEnabled ?? this.isEnabled,
      addedAt: addedAt,
      lastNotifiedAt: lastNotifiedAt ?? this.lastNotifiedAt,
    );
  }
}

/// Check-in de segurança
@MappableClass()
class SafetyCheckIn with SafetyCheckInMappable {
  final String checkInId;
  final String userId;
  final DateTime scheduledTime;
  final DateTime? checkedInAt;
  final String? location;
  final String? datePartnerUserId;
  final bool isEmergency;
  final String? emergencyMessage;
  final CheckInStatus status;

  const SafetyCheckIn({
    required this.checkInId,
    required this.userId,
    required this.scheduledTime,
    this.checkedInAt,
    this.location,
    this.datePartnerUserId,
    this.isEmergency = false,
    this.emergencyMessage,
    this.status = CheckInStatus.pending,
  });

  SafetyCheckIn copyWith({DateTime? checkedInAt, CheckInStatus? status, bool? isEmergency, String? emergencyMessage}) {
    return SafetyCheckIn(
      checkInId: checkInId,
      userId: userId,
      scheduledTime: scheduledTime,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      location: location,
      datePartnerUserId: datePartnerUserId,
      isEmergency: isEmergency ?? this.isEmergency,
      emergencyMessage: emergencyMessage ?? this.emergencyMessage,
      status: status ?? this.status,
    );
  }

  /// Verificar se está atrasado (15 min de tolerância)
  bool get isOverdue {
    if (status == CheckInStatus.completed) return false;
    final deadline = scheduledTime.add(const Duration(minutes: 15));
    return DateTime.now().isAfter(deadline);
  }
}

/// Status do check-in
enum CheckInStatus {
  pending, // Aguardando
  completed, // Completado
  missed, // Perdido (não fez check-in)
  emergency, // Emergência acionada
}

/// Configurações de segurança do usuário
@MappableClass()
class SafetySettings with SafetySettingsMappable {
  final String userId;
  final bool photoVerificationRequired; // Exigir verificação de fotos
  final bool shareLocationOnDates; // Compartilhar localização
  final bool enableCheckIns; // Ativar check-ins
  final bool autoNotifyEmergency; // Notificar contatos auto
  final int checkInReminderMinutes; // Minutos antes do lembrete
  final bool hideFromSearch; // Esconder de buscas
  final bool requireMessageApproval; // Aprovar mensagens antes
  final DateTime updatedAt;

  const SafetySettings({
    required this.userId,
    this.photoVerificationRequired = false,
    this.shareLocationOnDates = false,
    this.enableCheckIns = true,
    this.autoNotifyEmergency = true,
    this.checkInReminderMinutes = 30,
    this.hideFromSearch = false,
    this.requireMessageApproval = false,
    required this.updatedAt,
  });

  SafetySettings copyWith({
    bool? photoVerificationRequired,
    bool? shareLocationOnDates,
    bool? enableCheckIns,
    bool? autoNotifyEmergency,
    int? checkInReminderMinutes,
    bool? hideFromSearch,
    bool? requireMessageApproval,
  }) {
    return SafetySettings(
      userId: userId,
      photoVerificationRequired: photoVerificationRequired ?? this.photoVerificationRequired,
      shareLocationOnDates: shareLocationOnDates ?? this.shareLocationOnDates,
      enableCheckIns: enableCheckIns ?? this.enableCheckIns,
      autoNotifyEmergency: autoNotifyEmergency ?? this.autoNotifyEmergency,
      checkInReminderMinutes: checkInReminderMinutes ?? this.checkInReminderMinutes,
      hideFromSearch: hideFromSearch ?? this.hideFromSearch,
      requireMessageApproval: requireMessageApproval ?? this.requireMessageApproval,
      updatedAt: DateTime.now(),
    );
  }
}

/// Estatísticas de segurança
@MappableClass()
class SafetyStats with SafetyStatsMappable {
  final int totalReportsSubmitted;
  final int totalReportsReceived;
  final int activeBlocks;
  final int emergencyContactsCount;
  final int checkInsCompleted;
  final int checkInsMissed;
  final DateTime? lastReportDate;
  final double safetyScore; // 0-100

  const SafetyStats({
    required this.totalReportsSubmitted,
    required this.totalReportsReceived,
    required this.activeBlocks,
    required this.emergencyContactsCount,
    required this.checkInsCompleted,
    required this.checkInsMissed,
    this.lastReportDate,
    required this.safetyScore,
  });
}

/// Request para criar relatório
@MappableClass()
class CreateReportRequest with CreateReportRequestMappable {
  final String reportedUserId;
  final ReportReason reason;
  final String? customReason;
  final List<String> evidenceUrls;

  const CreateReportRequest({
    required this.reportedUserId,
    required this.reason,
    this.customReason,
    this.evidenceUrls = const [],
  });
}

/// Guia de segurança
@MappableClass()
class SafetyTip with SafetyTipMappable {
  final String tipId;
  final String title;
  final String description;
  final SafetyTipCategory category;
  final int priority; // 1-10
  final String? iconUrl;

  const SafetyTip({
    required this.tipId,
    required this.title,
    required this.description,
    required this.category,
    this.priority = 5,
    this.iconUrl,
  });
}

/// Categorias de dicas de segurança
enum SafetyTipCategory {
  beforeMeeting, // Antes de encontrar
  duringDate, // Durante o encontro
  onlinePrivacy, // Privacidade online
  photoSharing, // Compartilhar fotos
  personalInfo, // Informações pessoais
  redFlags, // Sinais de alerta
  reportingAbuse, // Como reportar
}
