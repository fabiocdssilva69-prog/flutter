import 'package:cloud_firestore/cloud_firestore.dart';

class MatchEntity {
  final String id;
  final List<String> userIds;
  final DateTime createdAt;
  final DateTime? lastInteractionAt;
  final bool isActive;

  MatchEntity({
    required this.id,
    required this.userIds,
    required this.createdAt,
    this.lastInteractionAt,
    this.isActive = true,
  });

  factory MatchEntity.fromMap(Map<String, dynamic> map, String id) {
    return MatchEntity(
      id: id,
      userIds: List<String>.from(map['userIds'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastInteractionAt: map['lastInteractionAt'] != null ? (map['lastInteractionAt'] as Timestamp).toDate() : null,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userIds': userIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastInteractionAt': lastInteractionAt != null ? Timestamp.fromDate(lastInteractionAt!) : null,
      'isActive': isActive,
    };
  }

  String getOtherUserId(String currentUserId) {
    return userIds.firstWhere((id) => id != currentUserId);
  }

  MatchEntity copyWith({
    String? id,
    List<String>? userIds,
    DateTime? createdAt,
    DateTime? lastInteractionAt,
    bool? isActive,
  }) {
    return MatchEntity(
      id: id ?? this.id,
      userIds: userIds ?? this.userIds,
      createdAt: createdAt ?? this.createdAt,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
