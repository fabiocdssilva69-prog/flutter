import 'package:cloud_firestore/cloud_firestore.dart'; // Para GeoPoint
import 'package:dart_mappable/dart_mappable.dart';
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

  final String? fcmToken;

  // NOVO (MÍDIA - Sprint 24): URL do Avatar e Lista de Portfólio
  final String? avatarUrl;
  final List<String> portfolioUrls;

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
  final bool isAvailable; // Disponível para agendamento agora
  final Map<String, String>? workingHours; // Ex: {'monday': '08:00-18:00', ...}
  final double rating; // Avaliação média (0-5)
  final int reviewCount; // Número de avaliações

  // NOVO (PREMIUM FEATURES - Phase 11): Sistema de Monetização
  final bool isPremium; // Usuário tem assinatura premium ativa
  @MappableField(hook: TimestampHook())
  final DateTime? premiumExpiresAt; // Data de expiração do premium
  final int superLikesRemaining; // Super likes restantes (free users: 1/dia, premium: -1 = ilimitado)
  final int boostsRemaining; // Boosts disponíveis (comprados ou ganhos)
  @MappableField(hook: TimestampHook())
  final DateTime? boostedUntil; // Data até quando o perfil está "boosted"
  final bool canSeeWhoLiked; // Pode ver quem deu like (premium feature)
  @MappableField(hook: TimestampHook())
  final DateTime? lastSuperLikeResetAt; // Última vez que o super like gratuito foi resetado

  // Aplicamos o Hook aos campos de data
  @MappableField(hook: TimestampHook())
  final DateTime createdAt;

  @MappableField(hook: TimestampHook())
  final DateTime? updatedAt;

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
    this.fcmToken,
    this.updatedAt,
    this.avatarUrl, // NOVO
    this.portfolioUrls = const [], // NOVO
    this.prompts = const [], // NOVO - Phase 1 (Prompts)
    this.mediaContent = const [], // NOVO - Phase 1 (Video/Audio)
    this.preciseLocation, // NOVO
    this.searchRadiusKm = 25, // Raio padrão inicial de 25KM
    this.hourlyRate, // NOVO - Phase 9/10
    this.services = const [], // NOVO - Phase 9/10
    this.isAvailable = true, // NOVO - Phase 9/10
    this.workingHours, // NOVO - Phase 10
    this.rating = 0.0, // NOVO - Phase 9/11
    this.reviewCount = 0, // NOVO - Phase 11
    this.isPremium = false, // NOVO - Phase 11 (Premium)
    this.premiumExpiresAt, // NOVO - Phase 11
    this.superLikesRemaining = 1, // NOVO - Phase 11 (1 super like grátis por dia)
    this.boostsRemaining = 0, // NOVO - Phase 11 (comprados via Stripe)
    this.boostedUntil, // NOVO - Phase 11
    this.canSeeWhoLiked = false, // NOVO - Phase 11 (premium only)
    this.lastSuperLikeResetAt, // NOVO - Phase 11
  });

  // Getter para converter preciseLocation de Map para GeoFirePoint
  GeoFirePoint? get geoLocation {
    if (preciseLocation == null) return null;
    try {
      final geopoint = preciseLocation!['geopoint'];
      if (geopoint is GeoPoint) {
        return GeoFirePoint(geopoint);
      }
    } catch (e) {
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

  // Método estático para deserialização (usado pelos repositórios)
  static const fromMap = ProfileEntityMapper.fromMap;
}
