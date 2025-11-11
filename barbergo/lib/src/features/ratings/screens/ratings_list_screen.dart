import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/rating_repository.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/rating_entity.dart';
import '../widgets/rating_stars.dart';

class RatingsListScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;

  const RatingsListScreen({required this.userId, required this.userName, super.key});

  @override
  ConsumerState<RatingsListScreen> createState() => _RatingsListScreenState();
}

class _RatingsListScreenState extends ConsumerState<RatingsListScreen> {
  bool _isLoading = true;
  RatingStats? _stats;
  List<RatingEntity> _ratings = [];
  Map<String, ProfileEntity?> _profilesCache = {};

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    try {
      final stats = await ref.read(ratingRepositoryProvider).getRatingStats(widget.userId);
      final ratings = await ref.read(ratingRepositoryProvider).getRatingsForUser(widget.userId);

      // Carregar perfis dos avaliadores
      final profileIds = ratings.map((r) => r.fromUserId).toSet();
      final profiles = <String, ProfileEntity?>{};

      for (final id in profileIds) {
        try {
          final profile = await ref.read(profileRepositoryProvider).getProfile(id);
          profiles[id] = profile;
        } catch (e) {
          profiles[id] = null;
        }
      }

      if (mounted) {
        setState(() {
          _stats = stats;
          _ratings = ratings;
          _profilesCache = profiles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar avaliações: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Avaliações de ${widget.userName}')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stats == null || !_stats!.hasRatings
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadRatings,
              child: CustomScrollView(
                slivers: [
                  // Header com estatísticas
                  SliverToBoxAdapter(child: _buildStatsHeader()),

                  // Lista de avaliações
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildRatingCard(_ratings[index]),
                        childCount: _ratings.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhuma avaliação ainda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'Seja o primeiro a avaliar ${widget.userName}!',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    if (_stats == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Média geral
          Text(
            _stats!.averageDisplay,
            style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          RatingStars(rating: _stats!.averageStars, size: 24, activeColor: Colors.amber),
          const SizedBox(height: 8),
          Text('${_stats!.totalRatings} avaliações', style: const TextStyle(fontSize: 16, color: Colors.white70)),

          const SizedBox(height: 24),

          // Distribuição de estrelas
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: RatingDistribution(
              distribution: _stats!.starsDistribution,
              totalRatings: _stats!.totalRatings,
              barColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(RatingEntity rating) {
    final profile = _profilesCache[rating.fromUserId];
    final formattedDate = DateFormat('dd/MM/yyyy').format(rating.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com perfil e estrelas
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  backgroundImage: profile?.portfolioUrls.isNotEmpty == true
                      ? NetworkImage(profile!.portfolioUrls.first)
                      : profile?.avatarUrl != null
                      ? NetworkImage(profile!.avatarUrl!)
                      : null,
                  child: (profile?.portfolioUrls.isEmpty == true && profile?.avatarUrl == null)
                      ? Text(
                          profile?.name[0].toUpperCase() ?? '?',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        )
                      : null,
                ),

                const SizedBox(width: 12),

                // Nome e data
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.name ?? 'Usuário Desconhecido',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(formattedDate, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),

                // Estrelas
                RatingStars(rating: rating.stars.toDouble(), size: 18),
              ],
            ),

            // Comentário
            if (rating.comment.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(rating.comment, style: const TextStyle(fontSize: 14, height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}
