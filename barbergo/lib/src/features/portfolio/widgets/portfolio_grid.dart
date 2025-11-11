import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../models/portfolio_item_entity.dart';

class PortfolioGrid extends StatelessWidget {
  final List<PortfolioItemEntity> items;
  final bool isOwner;
  final VoidCallback? onAddPressed;
  final Function(String itemId)? onDeletePressed;
  final Function(String itemId)? onEditPressed;
  final Function(String userId, String itemId)? onLikePressed;
  final String? currentUserId;
  final bool enableReorder;

  const PortfolioGrid({
    super.key,
    required this.items,
    this.isOwner = false,
    this.onAddPressed,
    this.onDeletePressed,
    this.onEditPressed,
    this.onLikePressed,
    this.currentUserId,
    this.enableReorder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && !isOwner) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Nenhuma foto no portfólio', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      );
    }

    if (items.isEmpty && isOwner) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Adicione fotos do seu trabalho', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Fotos'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: isOwner ? items.length + 1 : items.length,
      itemBuilder: (context, index) {
        // Add button for owner
        if (isOwner && index == items.length) {
          return _buildAddButton(context);
        }

        final item = items[index];
        return _buildPortfolioItem(context, item, index);
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: onAddPressed,
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: Center(child: Icon(Icons.add, size: 48, color: Colors.grey[600])),
      ),
    );
  }

  Widget _buildPortfolioItem(BuildContext context, PortfolioItemEntity item, int index) {
    return GestureDetector(
      onTap: () => _openGallery(context, index),
      onLongPress: isOwner ? () => _showItemOptions(context, item) : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.error_outline, color: Colors.grey[600]),
              ),
            ),
          ),

          // Gradient overlay for icons
          if (isOwner || onLikePressed != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Like button (for viewing other users)
                    if (!isOwner && onLikePressed != null && currentUserId != null)
                      GestureDetector(
                        onTap: () => onLikePressed!(item.userId, item.id),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.isLikedBy(currentUserId!) ? Icons.favorite : Icons.favorite_border,
                                size: 16,
                                color: item.isLikedBy(currentUserId!) ? Colors.red : Colors.white,
                              ),
                              if (item.likesCount > 0) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '${item.likesCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                    // Edit/Delete buttons (for owner)
                    if (isOwner)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEditPressed != null)
                            GestureDetector(
                              onTap: () => onEditPressed!(item.id),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.edit, size: 16, color: Colors.white),
                              ),
                            ),
                          if (onDeletePressed != null)
                            GestureDetector(
                              onTap: () => _confirmDelete(context, item),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.delete, size: 16, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text('${initialIndex + 1} / ${items.length}', style: const TextStyle(color: Colors.white)),
          ),
          body: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              final item = items[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(item.imageUrl),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: item.id),
              );
            },
            itemCount: items.length,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
            pageController: PageController(initialPage: initialIndex),
            onPageChanged: (index) {
              // Update title
            },
          ),
        ),
      ),
    );
  }

  void _showItemOptions(BuildContext context, PortfolioItemEntity item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEditPressed != null)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  onEditPressed!(item.id);
                },
              ),
            if (onDeletePressed != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, item);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PortfolioItemEntity item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir foto'),
        content: const Text('Tem certeza que deseja excluir esta foto?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDeletePressed!(item.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
