import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/repositories/auth_repository.dart';
import '../models/portfolio_item_entity.dart';

final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  return PortfolioRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
    authRepository: ref.watch(authRepositoryProvider),
  );
});

class PortfolioRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final AuthRepository _authRepository;

  PortfolioRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required AuthRepository authRepository,
  }) : _firestore = firestore,
       _storage = storage,
       _authRepository = authRepository;

  /// Watch portfolio items for current user
  Stream<List<PortfolioItemEntity>> watchUserPortfolio() {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('profiles')
        .doc(userId)
        .collection('portfolio')
        .orderBy('order', descending: false)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => PortfolioItemEntity.fromMap(doc.data(), doc.id)).toList();
        });
  }

  /// Upload image to portfolio
  Future<PortfolioItemEntity> uploadImage({
    required String imagePath,
    String? description,
    List<String> tags = const [],
  }) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Compress image before upload
    final compressedImage = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 1080,
      minHeight: 1080,
      quality: 85,
      format: CompressFormat.jpeg,
    );

    if (compressedImage == null) {
      throw Exception('Failed to compress image');
    }

    // Generate unique filename
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = _storage.ref().child('portfolio').child(userId).child(fileName);

    // Upload to Firebase Storage
    await storageRef.putData(compressedImage);
    final downloadUrl = await storageRef.getDownloadURL();

    // Get current item count for order
    final existingItems = await _firestore.collection('profiles').doc(userId).collection('portfolio').get();

    // Create portfolio item document
    final portfolioItem = PortfolioItemEntity(
      id: '', // Will be set by Firestore
      userId: userId,
      imageUrl: downloadUrl,
      storagePath: storageRef.fullPath,
      description: description,
      tags: tags,
      order: existingItems.docs.length,
      uploadedAt: DateTime.now(),
      likesCount: 0,
    );

    // Add to Firestore
    final docRef = await _firestore
        .collection('profiles')
        .doc(userId)
        .collection('portfolio')
        .add(portfolioItem.toMap());

    // Update profile portfolioUrls array for backward compatibility
    await _firestore.collection('profiles').doc(userId).update({
      'portfolioUrls': FieldValue.arrayUnion([downloadUrl]),
    });

    return portfolioItem.copyWith(id: docRef.id);
  }

  /// Upload multiple images in batch
  Future<List<PortfolioItemEntity>> uploadMultipleImages({
    required List<String> imagePaths,
    String? description,
    List<String> tags = const [],
  }) async {
    final List<PortfolioItemEntity> uploadedItems = [];

    for (var imagePath in imagePaths) {
      try {
        final item = await uploadImage(imagePath: imagePath, description: description, tags: tags);
        uploadedItems.add(item);
      } catch (e) {
        print('Error uploading image: $imagePath - $e');
        // Continue with other uploads even if one fails
      }
    }

    return uploadedItems;
  }

  /// Delete portfolio item
  Future<void> deletePortfolioItem(String itemId) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Get item data to delete from Storage
    final itemDoc = await _firestore.collection('profiles').doc(userId).collection('portfolio').doc(itemId).get();

    if (!itemDoc.exists) return;

    final item = PortfolioItemEntity.fromMap(itemDoc.data()!, itemDoc.id);

    // Delete from Storage
    try {
      await _storage.ref(item.storagePath).delete();
    } catch (e) {
      print('Error deleting from Storage: $e');
    }

    // Delete from Firestore
    await _firestore.collection('profiles').doc(userId).collection('portfolio').doc(itemId).delete();

    // Remove from profile portfolioUrls array
    await _firestore.collection('profiles').doc(userId).update({
      'portfolioUrls': FieldValue.arrayRemove([item.imageUrl]),
    });
  }

  /// Update portfolio item (description, tags)
  Future<void> updatePortfolioItem({required String itemId, String? description, List<String>? tags}) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final updateData = <String, dynamic>{};
    if (description != null) updateData['description'] = description;
    if (tags != null) updateData['tags'] = tags;

    if (updateData.isEmpty) return;

    await _firestore.collection('profiles').doc(userId).collection('portfolio').doc(itemId).update(updateData);
  }

  /// Reorder portfolio items
  Future<void> reorderPortfolio(List<String> itemIds) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();

    for (int i = 0; i < itemIds.length; i++) {
      final docRef = _firestore.collection('profiles').doc(userId).collection('portfolio').doc(itemIds[i]);

      batch.update(docRef, {'order': i});
    }

    await batch.commit();
  }

  /// Watch portfolio items for any user
  Stream<List<PortfolioItemEntity>> watchPortfolio(String userId) {
    return _firestore
        .collection('profiles')
        .doc(userId)
        .collection('portfolio')
        .orderBy('order', descending: false)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => PortfolioItemEntity.fromMap(doc.data(), doc.id)).toList();
        });
  }

  /// Increment like count
  Future<void> likePortfolioItem(String userId, String itemId) async {
    final currentUserId = _authRepository.currentUser?.uid;
    if (currentUserId == null) throw Exception('User not authenticated');

    final docRef = _firestore.collection('profiles').doc(userId).collection('portfolio').doc(itemId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;

      final likedBy = List<String>.from(doc.data()?['likedBy'] ?? []);

      if (likedBy.contains(currentUserId)) {
        // Unlike
        likedBy.remove(currentUserId);
        transaction.update(docRef, {'likedBy': likedBy, 'likesCount': FieldValue.increment(-1)});
      } else {
        // Like
        likedBy.add(currentUserId);
        transaction.update(docRef, {'likedBy': likedBy, 'likesCount': FieldValue.increment(1)});
      }
    });
  }
}
