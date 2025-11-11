import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/rating_repository.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../../domain/entities/rating_entity.dart';
import '../../ratings/screens/rating_screen.dart';
import '../../ratings/screens/ratings_list_screen.dart';
import '../../ratings/widgets/rating_stars.dart';

class ProfileDetailScreen extends ConsumerWidget {
  final ProfileEntity profile;
  final bool isCurrentUser;

  const ProfileDetailScreen({super.key, required this.profile, this.isCurrentUser = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                if (!isCurrentUser) _buildRateButton(context),
                const SizedBox(height: 16),
                _buildBioSection(context),
                if (profile.workingHours != null) _buildWorkingHoursSection(context),
                if (profile.services.isNotEmpty) _buildServicesSection(context),
                if (profile.priceRange != null) _buildPriceRangeSection(context),
                if (profile.address != null) _buildLocationSection(context),
                _buildSocialMediaSection(context),
                const SizedBox(height: 16),
                _buildPortfolioPreview(context),
                const SizedBox(height: 16),
                _buildRatingsSection(context),
                const SizedBox(height: 80), // Space for buttons
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'profile-${profile.userId}',
          child: profile.photoUrls.isNotEmpty
              ? PageView.builder(
                  itemCount: profile.photoUrls.length,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: profile.photoUrls[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    );
                  },
                )
              : Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 100, color: Colors.white),
                ),
        ),
      ),
      actions: [
        if (isCurrentUser)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile', arguments: profile);
            },
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (profile.reviewCount > 0)
                      RatingStars(rating: profile.rating, size: 20, showRating: true, count: profile.reviewCount)
                    else
                      Text(
                        'Nenhuma avaliação ainda',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600], fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
              ),
              if (profile.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Verificado',
                        style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (profile.distanceInKm != null)
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${profile.distanceInKm!.toStringAsFixed(1)} km de distância',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBioSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sobre', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(profile.bio, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horário de Funcionamento',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...profile.workingHours!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_getWeekdayName(entry.key), style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    entry.value ?? 'Fechado',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.green[700], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serviços Oferecidos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.services.map((service) {
              return Chip(
                label: Text(service),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Faixa de Preço', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.attach_money, color: Colors.green[700]),
              const SizedBox(width: 4),
              Text(
                'R\$ ${profile.priceRange!['min']} - R\$ ${profile.priceRange!['max']}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.green[700], fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Localização', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red[700]),
              const SizedBox(width: 8),
              Expanded(child: Text(profile.address!, style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _openMaps(context),
            icon: const Icon(Icons.directions),
            label: const Text('Abrir no Mapa'),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection(BuildContext context) {
    final hasInstagram = profile.instagramUrl != null && profile.instagramUrl!.isNotEmpty;
    final hasFacebook = profile.facebookUrl != null && profile.facebookUrl!.isNotEmpty;

    if (!hasInstagram && !hasFacebook) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Redes Sociais', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (hasInstagram)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchUrl(profile.instagramUrl!),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Instagram'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.purple[700]),
                  ),
                ),
              if (hasInstagram && hasFacebook) const SizedBox(width: 8),
              if (hasFacebook)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchUrl(profile.facebookUrl!),
                    icon: const Icon(Icons.facebook),
                    label: const Text('Facebook'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.blue[700]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Portfólio', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              // TODO: Adicionar navegação para PortfolioScreen quando implementado
            ],
          ),
        ),
        if (profile.portfolioUrls.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: profile.portfolioUrls.take(10).length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: profile.portfolioUrls[index],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Nenhuma foto no portfólio',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    if (isCurrentUser) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Open chat to negotiate hiring/application
                  // Navigate to chat with this professional
                },
                icon: const Icon(Icons.chat),
                label: const Text('Mensagem'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: View vacancy details or send application
                  // If viewing a barber: show "Candidatar-se"
                  // If viewing a barbershop: show "Ver Vagas"
                },
                icon: const Icon(Icons.work),
                label: const Text('Candidatar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(String key) {
    const weekdays = {
      'monday': 'Segunda',
      'tuesday': 'Terça',
      'wednesday': 'Quarta',
      'thursday': 'Quinta',
      'friday': 'Sexta',
      'saturday': 'Sábado',
      'sunday': 'Domingo',
    };
    return weekdays[key] ?? key;
  }

  Future<void> _openMaps(BuildContext context) async {
    if (profile.preciseLocation == null) return;

    final geopoint = profile.preciseLocation!['geopoint'];
    if (geopoint == null) return;

    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${geopoint.latitude},${geopoint.longitude}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Não foi possível abrir o mapa'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildRateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RatingScreen(targetUserId: profile.userId, targetName: profile.name),
            ),
          );
        },
        icon: const Icon(Icons.star),
        label: const Text('Avaliar'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  Widget _buildRatingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Avaliações', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              if (profile.reviewCount > 3)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingsListScreen(userId: profile.userId, userName: profile.name),
                      ),
                    );
                  },
                  child: const Text('Ver Todas'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRatingsPreview(context),
        ],
      ),
    );
  }

  Widget _buildRatingsPreview(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final ratingsStream = ref.watch(ratingRepositoryProvider).watchRatingsForUser(profile.userId);

        return StreamBuilder<List<RatingEntity>>(
          stream: ratingsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar avaliações', style: TextStyle(color: Colors.red)),
              );
            }

            final ratings = snapshot.data ?? [];

            if (ratings.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Icon(Icons.star_border, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text('Nenhuma avaliação ainda', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text('Seja o primeiro a avaliar!', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              );
            }

            final previewRatings = ratings.take(3).toList();

            return Column(
              children: [
                for (final rating in previewRatings) _buildRatingCard(context, ref, rating),
                if (ratings.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatingsListScreen(userId: profile.userId, userName: profile.name),
                          ),
                        );
                      },
                      child: Text('Ver todas as ${ratings.length} avaliações'),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRatingCard(BuildContext context, WidgetRef ref, RatingEntity rating) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingStars(rating: rating.stars.toDouble(), size: 16),
                Text(
                  DateFormat('dd/MM/yyyy').format(rating.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (rating.comment.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(rating.comment, style: const TextStyle(fontSize: 14), maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 4),
            FutureBuilder<ProfileEntity?>(
              future: ref.read(profileRepositoryProvider).getProfile(rating.fromUserId),
              builder: (context, snapshot) {
                final raterProfile = snapshot.data;
                return Text(
                  'por ${raterProfile?.name ?? 'Usuário'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
