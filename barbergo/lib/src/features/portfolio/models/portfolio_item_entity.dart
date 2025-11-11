import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioItemEntity {
  final String id;
  final String userId;
  final String imageUrl;
  final String storagePath;
  final String? description;
  final List<String> tags;
  final int order;
  final DateTime uploadedAt;
  final int likesCount;
  final List<String> likedBy;

  const PortfolioItemEntity({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.storagePath,
    this.description,
    this.tags = const [],
    required this.order,
    required this.uploadedAt,
    this.likesCount = 0,
    this.likedBy = const [],
  });

  factory PortfolioItemEntity.fromMap(Map<String, dynamic> map, String id) {
    return PortfolioItemEntity(
      id: id,
      userId: map['userId'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      storagePath: map['storagePath'] as String? ?? '',
      description: map['description'] as String?,
      tags: List<String>.from(map['tags'] ?? []),
      order: map['order'] as int? ?? 0,
      uploadedAt: (map['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likesCount: map['likesCount'] as int? ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'storagePath': storagePath,
      'description': description,
      'tags': tags,
      'order': order,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'likesCount': likesCount,
      'likedBy': likedBy,
    };
  }

  bool isLikedBy(String userId) {
    return likedBy.contains(userId);
  }

  PortfolioItemEntity copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? storagePath,
    String? description,
    List<String>? tags,
    int? order,
    DateTime? uploadedAt,
    int? likesCount,
    List<String>? likedBy,
  }) {
    return PortfolioItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      storagePath: storagePath ?? this.storagePath,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      order: order ?? this.order,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      likesCount: likesCount ?? this.likesCount,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  @override
  String toString() {
    return 'PortfolioItemEntity(id: $id, userId: $userId, imageUrl: $imageUrl, description: $description, tags: $tags, order: $order, likesCount: $likesCount)';
  }
}
