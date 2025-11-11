import 'package:dart_mappable/dart_mappable.dart';

part 'identity_verification.g.dart';

/// Entity para Identity Verification (Phase 3)
/// Sistema de verificação de identidade para aumentar confiança
@MappableClass()
class IdentityVerification with IdentityVerificationMappable {
  final String verificationId;
  final String userId;
  final VerificationType type;
  final VerificationStatus status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy; // Admin user ID
  final String? rejectionReason;
  final List<VerificationDocument> documents;
  final VerificationBadge? badge;
  final int attemptCount;
  final DateTime? nextAttemptAllowedAt;

  const IdentityVerification({
    required this.verificationId,
    required this.userId,
    required this.type,
    required this.status,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
    required this.documents,
    this.badge,
    this.attemptCount = 1,
    this.nextAttemptAllowedAt,
  });

  /// Copiar com novos valores
  IdentityVerification copyWith({
    VerificationStatus? status,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
    VerificationBadge? badge,
    int? attemptCount,
    DateTime? nextAttemptAllowedAt,
  }) {
    return IdentityVerification(
      verificationId: verificationId,
      userId: userId,
      type: type,
      status: status ?? this.status,
      submittedAt: submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      documents: documents,
      badge: badge ?? this.badge,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAllowedAt: nextAttemptAllowedAt ?? this.nextAttemptAllowedAt,
    );
  }

  /// Verificar se está aprovado
  bool get isVerified => status == VerificationStatus.approved;

  /// Verificar se pode tentar novamente
  bool get canRetry {
    if (nextAttemptAllowedAt == null) return true;
    return DateTime.now().isAfter(nextAttemptAllowedAt!);
  }
}

/// Tipos de verificação disponíveis
enum VerificationType {
  photoVerification, // Selfie + pose específica
  documentVerification, // ID/CNH/Passaporte
  phoneVerification, // SMS
  emailVerification, // Email link
  socialMediaLink, // Instagram/LinkedIn verificado
  videoVerification, // Vídeo dizendo código
}

/// Status da verificação
enum VerificationStatus {
  pending, // Aguardando análise
  underReview, // Em análise
  approved, // Aprovado
  rejected, // Rejeitado
  expired, // Expirado (precisa renovar)
}

/// Documento de verificação
@MappableClass()
class VerificationDocument with VerificationDocumentMappable {
  final String documentId;
  final DocumentType type;
  final String fileUrl;
  final String? fileHash; // Para integridade
  final DateTime uploadedAt;
  final Map<String, dynamic> metadata; // Dados extraídos (OCR, face detection)

  const VerificationDocument({
    required this.documentId,
    required this.type,
    required this.fileUrl,
    this.fileHash,
    required this.uploadedAt,
    this.metadata = const {},
  });
}

/// Tipos de documento
enum DocumentType {
  selfiePhoto, // Selfie normal
  selfieWithPose, // Selfie com pose específica
  governmentId, // RG/CNH
  passport, // Passaporte
  driverLicense, // CNH
  videoSelfie, // Vídeo selfie
  utilityBill, // Conta de serviço (prova de endereço)
}

/// Badge de verificação
@MappableClass()
class VerificationBadge with VerificationBadgeMappable {
  final String badgeId;
  final BadgeLevel level;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final Set<VerificationType> verificationsCompleted;
  final int trustScore; // 0-100

  const VerificationBadge({
    required this.badgeId,
    required this.level,
    required this.issuedAt,
    required this.expiresAt,
    required this.verificationsCompleted,
    required this.trustScore,
  });

  /// Verificar se está expirado
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Verificar se precisa renovar (30 dias antes)
  bool get needsRenewal {
    final renewalDate = expiresAt.subtract(const Duration(days: 30));
    return DateTime.now().isAfter(renewalDate);
  }

  /// Cor do badge
  String get color {
    switch (level) {
      case BadgeLevel.basic:
        return '#3B82F6'; // Blue
      case BadgeLevel.verified:
        return '#10B981'; // Green
      case BadgeLevel.premium:
        return '#F59E0B'; // Gold
      case BadgeLevel.elite:
        return '#8B5CF6'; // Purple
    }
  }

  /// Ícone do badge
  String get icon {
    switch (level) {
      case BadgeLevel.basic:
        return '✓';
      case BadgeLevel.verified:
        return '✓✓';
      case BadgeLevel.premium:
        return '★';
      case BadgeLevel.elite:
        return '♛';
    }
  }
}

/// Níveis de badge
enum BadgeLevel {
  basic, // 1 verificação (email/phone)
  verified, // 2+ verificações (photo + document)
  premium, // 3+ verificações (photo + document + video)
  elite, // 4+ verificações (full stack)
}

/// Request para iniciar verificação
@MappableClass()
class VerificationRequest with VerificationRequestMappable {
  final String userId;
  final VerificationType type;
  final Map<String, dynamic> additionalData;

  const VerificationRequest({required this.userId, required this.type, this.additionalData = const {}});
}

/// Response da verificação
@MappableClass()
class VerificationResult with VerificationResultMappable {
  final bool success;
  final String? verificationId;
  final VerificationStatus? status;
  final String? message;
  final VerificationBadge? badge;
  final List<String> nextSteps; // Próximas verificações sugeridas

  const VerificationResult({
    required this.success,
    this.verificationId,
    this.status,
    this.message,
    this.badge,
    this.nextSteps = const [],
  });
}

/// Estatísticas de verificação
@MappableClass()
class VerificationStats with VerificationStatsMappable {
  final int totalVerifications;
  final int approvedCount;
  final int rejectedCount;
  final int pendingCount;
  final double approvalRate;
  final Map<VerificationType, int> verificationsByType;
  final DateTime lastVerifiedAt;

  const VerificationStats({
    required this.totalVerifications,
    required this.approvedCount,
    required this.rejectedCount,
    required this.pendingCount,
    required this.approvalRate,
    required this.verificationsByType,
    required this.lastVerifiedAt,
  });
}
