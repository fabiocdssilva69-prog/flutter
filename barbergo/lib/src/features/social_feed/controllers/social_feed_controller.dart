import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'social_feed_controller.g.dart';

/// Post da galeria social
class SocialPost {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String imageUrl;
  final String caption;
  final List<String> tags;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final bool isLiked;

  SocialPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.imageUrl,
    required this.caption,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.createdAt,
    this.isLiked = false,
  });

  factory SocialPost.fromFirestore(Map<String, dynamic> data, String id) {
    return SocialPost(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      caption: data['caption'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isLiked: data['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'imageUrl': imageUrl,
      'caption': caption,
      'tags': tags,
      'likes': likes,
      'comments': comments,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SocialPost copyWith({bool? isLiked, int? likes}) {
    return SocialPost(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      imageUrl: imageUrl,
      caption: caption,
      tags: tags,
      likes: likes ?? this.likes,
      comments: comments,
      createdAt: createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

@riverpod
class SocialFeedController extends _$SocialFeedController {
  @override
  Future<List<SocialPost>> build() async {
    return _loadFeed();
  }

  Future<List<SocialPost>> _loadFeed() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('social_posts')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) => SocialPost.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> createPost({
    required String userId,
    required String userName,
    required String userAvatar,
    required String imageUrl,
    required String caption,
    List<String> tags = const [],
  }) async {
    final post = SocialPost(
      id: '',
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      imageUrl: imageUrl,
      caption: caption,
      tags: tags,
      likes: 0,
      comments: 0,
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance.collection('social_posts').add(post.toFirestore());

    ref.invalidateSelf();
  }

  Future<void> toggleLike(String postId, String userId) async {
    final posts = state.value ?? [];
    final postIndex = posts.indexWhere((p) => p.id == postId);

    if (postIndex == -1) return;

    final post = posts[postIndex];
    final newLiked = !post.isLiked;
    final newLikes = newLiked ? post.likes + 1 : post.likes - 1;

    // Atualizar localmente
    state = AsyncValue.data(
      posts.map((p) => p.id == postId ? p.copyWith(isLiked: newLiked, likes: newLikes) : p).toList(),
    );

    // Atualizar no Firebase
    final likeRef = FirebaseFirestore.instance.collection('social_posts').doc(postId).collection('likes').doc(userId);

    if (newLiked) {
      await likeRef.set({'timestamp': FieldValue.serverTimestamp()});
      await FirebaseFirestore.instance.collection('social_posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      });
    } else {
      await likeRef.delete();
      await FirebaseFirestore.instance.collection('social_posts').doc(postId).update({
        'likes': FieldValue.increment(-1),
      });
    }
  }

  Future<void> deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('social_posts').doc(postId).delete();

    ref.invalidateSelf();
  }
}
