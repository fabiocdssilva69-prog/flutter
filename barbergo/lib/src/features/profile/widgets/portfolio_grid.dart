import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/async_value_ui.dart';
import '../controllers/media_controller.dart';

class PortfolioGrid extends ConsumerWidget {
  final List<String> imageUrls;
  final bool isEditing; // Define se os botões de ação devem ser mostrados

  const PortfolioGrid({super.key, required this.imageUrls, this.isEditing = false});

  void _addImage(WidgetRef ref) async {
    // Chama o upload de imagem (isAvatar: false)
    await ref.read(mediaControllerProvider.notifier).uploadImage(false);
  }

  void _removeImage(BuildContext context, WidgetRef ref, String url) async {
    // Confirmação de exclusão
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remover Imagem"),
        content: const Text("Tem certeza que deseja remover esta imagem do seu portfólio?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancelar")),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Remover", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(mediaControllerProvider.notifier).removePortfolioImage(url);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listener para erros durante upload/exclusão (mostra alertas)
    ref.listen(mediaControllerProvider, (_, state) => state.showAlertDialogOnError(context));
    // Estado de loading do MediaController
    final isLoading = ref.watch(mediaControllerProvider).isLoading;

    const maxImages = 6;
    final canAddMore = imageUrls.length < maxImages;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Impede scroll se estiver em um ScrollView pai
      shrinkWrap: true, // Ajusta o tamanho do grid ao conteúdo
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      // O itemCount inclui o botão de adicionar se estiver editando e puder adicionar mais
      itemCount: imageUrls.length + (isEditing && canAddMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Se for o último item e puder adicionar, mostra o botão
        if (isEditing && canAddMore && index == imageUrls.length) {
          return _buildAddButton(ref, isLoading);
        }

        // Mostra a imagem
        return _buildImageTile(context, ref, imageUrls[index], isLoading);
      },
    );
  }

  Widget _buildAddButton(WidgetRef ref, bool isLoading) {
    return InkWell(
      onTap: isLoading ? null : () => _addImage(ref),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!, width: 2),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[100],
        ),
        child: Center(
          // Mostra spinner se estiver carregando (uploading)
          child: isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : const Icon(Icons.add_a_photo_outlined, size: 30),
        ),
      ),
    );
  }

  Widget _buildImageTile(BuildContext context, WidgetRef ref, String url, bool isLoading) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem com Cache
          CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          // Botão de Remover (se estiver editando)
          if (isEditing)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                // Desabilita o botão se estiver carregando (uploading/deleting)
                onPressed: isLoading ? null : () => _removeImage(context, ref, url),
              ),
            ),
        ],
      ),
    );
  }
}
