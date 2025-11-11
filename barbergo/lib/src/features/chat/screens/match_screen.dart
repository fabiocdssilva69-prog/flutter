import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/l10n_helper.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/chat/chat_room_entity.dart';
import '../../core/core_data_controller.dart';
import '../../profile/widgets/user_avatar.dart';

class MatchScreen extends ConsumerStatefulWidget {
  // Recebe a sala de chat recém-criada
  final ChatRoomEntity room;

  const MatchScreen({super.key, required this.room});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // Inicia a animação automaticamente
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid;
    // Identifica o outro participante
    final otherUserId = widget.room.participantIds.firstWhere((id) => id != currentUserId, orElse: () => 'unknown');
    final otherUserName = widget.room.participants[otherUserId]?.name ?? "Usuário";

    // Busca os detalhes do outro usuário (para o Avatar) usando o CoreDataController
    final otherUserProfileAsync = ref.watch(userDetailsProvider(otherUserId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Confetti no centro superior
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Direção para baixo
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
              shouldLoop: false,
              colors: const [Colors.pink, Colors.red, Colors.purple, Colors.orange, Colors.yellow, Colors.blue],
            ),
          ),
          // Conteúdo principal
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Título Celebratório
                    Text(
                      context.l10n.itsAMatch,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.matchMessage(otherUserName),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),

                    // Avatar do outro usuário
                    otherUserProfileAsync.when(
                      data: (profile) => UserAvatar(imageUrl: profile?.avatarUrl, radius: 70),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, s) => const UserAvatar(radius: 70),
                    ),

                    const Spacer(flex: 2),

                    // Botão Principal: Ir para o Chat
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navega para o chat, substituindo a tela de match na pilha
                        context.pushReplacement('/direct-message', extra: widget.room);
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: Text(context.l10n.startConversation),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botão Secundário: Voltar (fecha o modal/tela)
                    OutlinedButton(onPressed: () => context.pop(), child: Text(context.l10n.continueBrowsing)),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
