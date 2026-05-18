import 'package:cloud_firestore/cloud_firestore.dart'; // Para GeoPoint
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart'; // NOVO: Sprint 24

import '../../core/infrastructure/mappable_hooks.dart'; // Importa o Hook
import 'enums.dart';
import 'media_content.dart'; // NOVO: Phase 1 - Video/Audio
import 'prompt_response.dart'; // NOVO: Phase 1 - Prompts System

// O arquivo gerado agora será .mapper.dart
part 'profile_entity.mapper.dart';

@MappableClass()
class ProfileEntity with ProfileEntityMappable {
  final String userId;
  final AccountType accountType;
  final String name;
  final String email;

  // dart_mappable usa valores padrão no construtor.
  final String bio;
  // 'location' é a descrição textual (Ex: "Biguaçu, SC")
  final String location;
  final String contactPhone;

  // NOVO: Nacionalidade (código do país ISO 3166-1 alpha-2: 'BR', 'US', 'AR', etc.)
  final String nationality;

  final String? fcmToken;

  // NOVO (MÍDIA - Sprint 24): URL do Avatar e Lista de Portfólio
  final String? avatarUrl;
  final List<String> portfolioUrls;

  // Social Links (Phase 1)
  final String? instagramUrl;
  final String? facebookUrl;
  final String? websiteUrl;

  // NOVO (PROMPTS - Phase 1): Sistema de prompts estilo Hinge (3 obrigatórios)
  final List<PromptResponse> prompts;

  // NOVO (MEDIA - Phase 1): Video/Audio profiles
  final List<MediaContent> mediaContent;

  // NOVO (GEO - Sprint 24): Localização Exata (GeoPoint e Geohash encapsulados)
  // Armazenado como Map para compatibilidade com dart_mappable
  @MappableField(hook: GeoFirePointHook())
  final Map<String, dynamic>? preciseLocation;

  // NOVO (GEO - Sprint 24): Preferência de Raio de Busca (em KM)
  final int searchRadiusKm;

  // NOVO (FILTROS & AGENDAMENTO - Phase 9/10): Dados do Barbeiro
  final double? hourlyRate; // Preço por hora (ex: 80.0)
  final List<String> services; // Serviços oferecidos ['Corte', 'Barba', ...]
  final List<String> serviceTypes; // Alias para services (compatibilidade)
  final bool isAvailable; // Disponível para agendamento agora
  final Map<String, String> workingHours; // Ex: {'monday': '08:00-18:00', ...}
  final double rating; // Avaliação média (0-5)
  final int reviewCount; // Número de avaliações

  // NOVO (PREMIUM FEATURES - Phase 11): Sistema de Monetização
  final bool isPremium; // Usuário tem assinatura premium ativa
  @MappableField(hook: TimestampHook())
  final DateTime? premiumExpiresAt; // Data de expiração do premium
  final int superLikesRemaining; // Super likes restantes (free users: 1/dia, premium: -1 = ilimitado)
  final int magicLikesRemaining; // Magic likes disponíveis (recurso especial)
  final int boostsRemaining; // Boosts disponíveis (comprados ou ganhos)
  final int replaysRemaining; // Replays disponíveis (permite voltar e dar like em perfis passados)
  @MappableField(hook: TimestampHook())
  final DateTime? boostedUntil; // Data até quando o perfil está "boosted"
  final bool canSeeWhoLiked; // Pode ver quem deu like (premium feature)
  @MappableField(hook: TimestampHook())
  final DateTime? lastSuperLikeResetAt; // Última vez que o super like gratuito foi resetado
  @MappableField(hook: TimestampHook())
  final DateTime? lastLikedAt; // NOVO: Último like RECEBIDO (para ordenação de Discovery)

  // NOVO (VERIFICATION BADGES - Phase 12): Selos de Verificação Silver/Gold
  final VerificationBadge verificationBadge; // Selo de verificação (none, silver, gold)
  @MappableField(hook: TimestampHook())
  final DateTime? badgeExpiresAt; // Expiração do selo (7 dias grátis ou assinatura)
  final bool hideReadReceipts; // Privacidade: ocultar confirmação de leitura (Silver/Gold feature)
  final bool invisibleMode; // NOVO: Modo invisível (Gold feature) - perfil não aparece em Discovery

  // NOVO (DOCUMENT VERIFICATION - Phase 13): Verificação de Identidade com IA
  final bool isDocumentVerified; // Documento verificado pela IA
  final String? documentVerificationStatus; // 'pending', 'verified', 'rejected'
  final String? documentVerificationUrl; // URL da foto da selfie com documento
  final String? documentRejectedReason; // Motivo da rejeição (se aplicável)
  @MappableField(hook: TimestampHook())
  final DateTime? documentVerifiedAt; // Data da verificação

  // Integração Google Business
  final String? googlePlaceId; // ID do local no Google Maps (para importar reviews)

  // Sistema de indicação
  final String? invitedBy; // UID do usuário que indicou este perfil

  // NOVO: Profissões adicionais (Barbeiro que também é Cabeleireiro, Barbearia que também é Salão)
  final bool isHairdresser; // Barbeiro que também é Cabeleireiro
  final bool isSalon; // Barbearia que também é Salão

  // Aplicamos o Hook aos campos de data
  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  @MappableField(hook: TimestampHook())
  final DateTime? updatedAt;

  @MappableField(hook: TimestampHook())
  final DateTime? birthDate;

  // Construtor com valores padrão
  ProfileEntity({
    required this.userId,
    required this.accountType,
    required this.name,
    required this.email,
    required this.createdAt,
    this.bio = '',
    this.location = '',
    this.contactPhone = '',
    this.nationality = 'BR', // Padrão Brasil
    this.fcmToken,
    this.updatedAt,
    this.birthDate,
    this.avatarUrl, // NOVO
    this.portfolioUrls = const [], // NOVO
    this.instagramUrl, // Social Links
    this.facebookUrl,
    this.websiteUrl,
    this.prompts = const [], // NOVO - Phase 1 (Prompts)
    this.mediaContent = const [], // NOVO - Phase 1 (Video/Audio)
    this.preciseLocation, // NOVO
    this.searchRadiusKm = 25, // Raio padrão inicial de 25KM
    this.hourlyRate, // NOVO - Phase 9/10
    this.services = const [], // NOVO - Phase 9/10
    List<String>? serviceTypes, // NOVO - Alias para services
    this.isAvailable = true, // NOVO - Phase 9/10
    this.workingHours = const {}, // NOVO - Phase 10
    this.rating = 0.0, // NOVO - Phase 9/11
    this.reviewCount = 0, // NOVO - Phase 11
    this.isPremium = false, // NOVO - Phase 11 (Premium)
    this.premiumExpiresAt, // NOVO - Phase 11
    this.superLikesRemaining = 1, // 1 grátis para testar
    this.magicLikesRemaining = 1, // 1 grátis para testar
    this.boostsRemaining = 1,     // 1 grátis para testar
    this.replaysRemaining = 1,    // 1 grátis para testar
    this.boostedUntil, // NOVO - Phase 11
    this.canSeeWhoLiked = false, // NOVO - Phase 11 (premium only)
    this.lastSuperLikeResetAt, // NOVO - Phase 11
    this.lastLikedAt, // NOVO: Último like RECEBIDO (para ordenação)
    VerificationBadge? verificationBadge, // NOVO - Phase 12 (Selos)
    this.hideReadReceipts = false, // NOVO - Phase 12 (Privacidade inversa)
    this.invisibleMode = false, // NOVO - Modo invisível (Gold feature)
    this.isDocumentVerified = false, // NOVO - Phase 13 (Documento verificado)
    this.documentVerificationStatus, // NOVO - Phase 13 ('pending', 'verified', 'rejected')
    this.documentVerificationUrl, // NOVO - Phase 13 (URL da selfie com documento)
    this.documentRejectedReason, // NOVO - Phase 13 (Motivo da rejeição)
    this.documentVerifiedAt, // NOVO - Phase 13 (Data da verificação)
    this.badgeExpiresAt, // Expiração do selo (7 dias grátis ou assinatura)
    this.googlePlaceId, // Google Business Place ID
    this.invitedBy, // UID do indicador
    this.isHairdresser = false, // NOVO - Barbeiro que também é Cabeleireiro
    this.isSalon = false, // NOVO - Barbearia que também é Salão
  }) : verificationBadge = verificationBadge ?? VerificationBadge.none,
       serviceTypes = serviceTypes ?? services;

  // Getter para converter preciseLocation de Map para GeoFirePoint
  GeoFirePoint? get geoLocation {
    if (preciseLocation == null) return null;
    try {
      final geopoint = preciseLocation!['geopoint'];
      // CORREÇÃO 10: Fallback para dados ausentes
      if (geopoint == null) return null;

      if (geopoint is GeoPoint) {
        return GeoFirePoint(geopoint);
      }
      // CORREÇÃO 3: Se for Map (como salvamos), converte de volta para GeoPoint
      if (geopoint is Map) {
        final lat = geopoint['latitude'] as double?;
        final lon = geopoint['longitude'] as double?;
        if (lat != null && lon != null) {
          return GeoFirePoint(GeoPoint(lat, lon));
        }
      }
    } catch (e) {
      debugPrint('⚠️ [ProfileEntity] Erro ao converter geoLocation: $e');
      return null;
    }
    return null;
  }

  // PREMIUM FEATURES - Getters e Helper Methods

  /// Verifica se o usuário tem premium ativo
  bool get hasActivePremium {
    if (!isPremium) return false;
    if (premiumExpiresAt == null) return true; // Premium vitalício (edge case)
    return DateTime.now().isBefore(premiumExpiresAt!);
  }

  /// Verifica se o perfil está boosted no momento
  bool get isBoosted {
    if (boostedUntil == null) return false;
    return DateTime.now().isBefore(boostedUntil!);
  }

  /// Verifica se o usuário pode usar super like agora
  bool get canUseSuperLike {
    // Premium tem super likes ilimitados
    if (hasActivePremium) return true;
    // Free users: verifica se tem super likes restantes
    return superLikesRemaining > 0;
  }

  /// Verifica se o usuário pode ativar boost
  bool get canActivateBoost {
    return boostsRemaining > 0 && !isBoosted;
  }

  /// Verifica se o super like gratuito precisa ser resetado (usuários free)
  bool get needsSuperLikeReset {
    if (hasActivePremium) return false; // Premium não precisa reset
    if (lastSuperLikeResetAt == null) return true; // Primeira vez

    final lastReset = lastSuperLikeResetAt!;
    final now = DateTime.now();

    // Verifica se já passou um dia desde o último reset
    return now.difference(lastReset).inHours >= 24;
  }

  /// Retorna o número de super likes disponíveis (para exibição)
  /// Premium: retorna -1 (ilimitado)
  /// Free: retorna número real
  int get displaySuperLikes {
    return hasActivePremium ? -1 : superLikesRemaining;
  }

  // VERIFICATION BADGE FEATURES - Phase 12

  /// Verifica se o usuário tem selo de verificação (Silver ou Gold)
  bool get hasVerificationBadge {
    return verificationBadge == VerificationBadge.silver || verificationBadge == VerificationBadge.gold;
  }

  /// Verifica se o usuário tem selo Gold
  bool get hasGoldBadge {
    return verificationBadge == VerificationBadge.gold;
  }

  /// Verifica se o usuário tem selo Silver
  bool get hasSilverBadge {
    return verificationBadge == VerificationBadge.silver;
  }

  /// Verifica se o usuário pode ocultar confirmação de leitura
  /// Apenas Silver e Gold podem usar essa feature
  bool get canHideReadReceipts {
    return hasVerificationBadge;
  }

  /// Retorna se confirmação de leitura deve ser mostrada para outros
  /// Lógica inversa: default = mostrar (false), premium pode ocultar (true)
  bool get shouldShowReadReceipts {
    // Se não tem badge, sempre mostra
    if (!hasVerificationBadge) return true;
    // Se tem badge mas optou por ocultar, não mostra
    return !hideReadReceipts;
  }

  // Método estático para deserialização (usado pelos repositórios)
  static const fromMap = ProfileEntityMapper.fromMap;
}
