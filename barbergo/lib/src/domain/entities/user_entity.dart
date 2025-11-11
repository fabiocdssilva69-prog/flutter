import 'package:dart_mappable/dart_mappable.dart';

import 'enums.dart';

part 'user_entity.mapper.dart';

/// Entity simplificada para User (quando precisar de dados básicos sem profile completo)
@MappableClass()
class UserEntity with UserEntityMappable {
  final String userId;
  final AccountType accountType;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.userId,
    required this.accountType,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// Construtor de factory do Firestore
  factory UserEntity.fromMap(Map<String, dynamic> map, String userId) {
    return UserEntity(
      userId: userId,
      accountType: AccountType.values.firstWhere(
        (e) => e.toString().split('.').last == (map['accountType'] as String? ?? 'customer'),
        orElse: () => AccountType.customer,
      ),
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatarUrl: map['avatarUrl'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
    );
  }

  /// Converter para Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'accountType': accountType.toString().split('.').last,
      'name': name,
      'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
