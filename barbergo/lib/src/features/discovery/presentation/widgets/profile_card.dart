import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/geo_distance_calculator.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../../profile/controllers/profile_controller.dart';

class ProfileCard extends ConsumerWidget {
  final ProfileEntity profile;

  const ProfileCard({super.key, required this.profile});

  GeoPoint? _extractGeoPoint(Map<String, dynamic>? preciseLocation) {
    if (preciseLocation == null) return null;
    try {
      final geopoint = preciseLocation['geopoint'];
      if (geopoint is GeoPoint) return geopoint;
    } catch (e) {
      debugPrint('⚠️ [GeoPoint] Error extracting GeoPoint: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obter usuário atual para calcular distância
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final currentUser = currentUserAsync.value;

    // Calcular distância se ambos tiverem localização precisa
    String? distance;
    final userGeoPoint = _extractGeoPoint(currentUser?.preciseLocation);
    final profileGeoPoint = _extractGeoPoint(profile.preciseLocation);

    if (userGeoPoint != null && profileGeoPoint != null) {
      try {
        final distanceKm = GeoDistanceCalculator.calculateDistance(userGeoPoint, profileGeoPoint);
        distance = GeoDistanceCalculator.formatDistance(distanceKm);
        debugPrint('📍 [Distance] ${profile.name}: $distance');
      } catch (e) {
        debugPrint('⚠️ [Distance] Error calculating distance: $e');
      }
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Image with Loading/Error States
            if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: profile.avatarUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                memCacheWidth: 800, // Optimize memory
                memCacheHeight: 1200,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[400],
                  child: const Icon(Icons.person, size: 80, color: Colors.white),
                ),
              )
            else
              Container(
                color: Colors.grey[400],
                child: const Center(child: Icon(Icons.person, size: 80, color: Colors.white)),
              ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Mostrar distância se disponível
                  if (distance != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.near_me, size: 16, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            '$distance de você',
                            style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  // NOVO: Mostrar prompts se disponíveis (Phase 1)
                  if (profile.prompts.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ...profile.prompts.take(2).map((prompt) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prompt.promptText,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prompt.response,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )),
                  ] else
                    Text(
                      profile.bio.isNotEmpty ? profile.bio : 'Sem descrição',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          profile.location.isNotEmpty ? profile.location : 'Localização não informada',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
