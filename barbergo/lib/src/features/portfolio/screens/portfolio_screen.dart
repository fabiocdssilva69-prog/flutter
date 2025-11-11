import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/portfolio_controller.dart';
import '../widgets/portfolio_grid.dart';
import '../widgets/upload_progress_overlay.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  final String? userId; // null = current user's portfolio
  final bool isOwner;

  const PortfolioScreen({super.key, this.userId, this.isOwner = true});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;
  int _uploadProgress = 0;
  int _totalUploads = 0;
  String? _currentFileName;

  @override
  Widget build(BuildContext context) {
    final portfolioStream = widget.userId != null
        ? ref.watch(portfolioProvider(widget.userId!))
        : ref.watch(userPortfolioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfólio'),
        actions: [
          if (widget.isOwner)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: _showImageSourceOptions,
              tooltip: 'Adicionar fotos',
            ),
        ],
      ),
      body: Stack(
        children: [
          portfolioStream.when(
            data: (items) => PortfolioGrid(
              items: items,
              isOwner: widget.isOwner,
              onAddPressed: widget.isOwner ? _showImageSourceOptions : null,
              onDeletePressed: widget.isOwner ? _deletePortfolioItem : null,
              onEditPressed: widget.isOwner ? _editPortfolioItem : null,
              onLikePressed: !widget.isOwner ? _toggleLike : null,
              currentUserId: widget.userId,
              enableReorder: widget.isOwner,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar portfólio', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(userPortfolioProvider),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          ),
          if (_isUploading)
            UploadProgressOverlay(current: _uploadProgress, total: _totalUploads, currentFileName: _currentFileName),
        ],
      ),
      floatingActionButton: widget.isOwner
          ? FloatingActionButton(onPressed: _showImageSourceOptions, child: const Icon(Icons.add_a_photo))
          : null,
    );
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImages(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () {
                Navigator.pop(context);
                _pickImages(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        // Pick multiple images from gallery
        final List<XFile> images = await _imagePicker.pickMultiImage(imageQuality: 85);

        if (images.isEmpty) return;

        await _uploadImages(images);
      } else {
        // Pick single image from camera
        final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);

        if (image == null) return;

        await _uploadImages([image]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao selecionar imagens: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _uploadImages(List<XFile> images) async {
    if (images.isEmpty) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
      _totalUploads = images.length;
    });

    try {
      final controller = ref.read(portfolioControllerProvider.notifier);

      for (int i = 0; i < images.length; i++) {
        setState(() {
          _uploadProgress = i + 1;
          _currentFileName = images[i].name;
        });

        await controller.uploadImage(imagePath: images[i].path, description: null, tags: []);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              images.length == 1 ? 'Foto adicionada com sucesso!' : '${images.length} fotos adicionadas com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao enviar imagens: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0;
          _totalUploads = 0;
          _currentFileName = null;
        });
      }
    }
  }

  Future<void> _deletePortfolioItem(String itemId) async {
    try {
      final controller = ref.read(portfolioControllerProvider.notifier);
      await controller.deletePortfolioItem(itemId);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Foto excluída com sucesso!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao excluir foto: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _editPortfolioItem(String itemId) {
    // TODO: Navigate to edit screen
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edição de descrição e tags - Em breve!')));
  }

  Future<void> _toggleLike(String userId, String itemId) async {
    try {
      final controller = ref.read(portfolioControllerProvider.notifier);
      await controller.toggleLike(userId, itemId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao curtir foto: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
