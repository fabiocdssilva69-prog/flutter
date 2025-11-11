import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/match_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import 'widgets/match_card.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      return const Center(child: Text('Usuário não autenticado'));
    }

    final matchesStream = ref.watch(matchRepositoryProvider).watchUserMatches(currentUser.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Matches'), centerTitle: true),
      body: StreamBuilder(
        stream: matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final matches = snapshot.data ?? [];

          if (matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Nenhum match ainda', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  const Text('Continue dando likes para encontrar matches!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final otherUserId = match.getOtherUserId(currentUser.uid);

              // Buscar perfil do outro usuário
              return FutureBuilder(
                future: ref.read(profileRepositoryProvider).getProfile(otherUserId),
                builder: (context, profileSnapshot) {
                  if (!profileSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final otherUserProfile = profileSnapshot.data!;
                  return MatchCard(match: match, otherUserProfile: otherUserProfile);
                },
              );
            },
          );
        },
      ),
    );
  }
}
