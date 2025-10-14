import 'package:cloud_firestore/cloud_firestore.dart';

import 'enums.dart';

class UserEntity {
  const UserEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.accountType,
    required this.subscriptionTier,
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String name;
  final AccountType accountType;
  final SubscriptionTier subscriptionTier;
  final DateTime createdAt;

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      accountType: AccountType.values.firstWhere(
        (e) => e.toString().split('.').last == json['accountType'],
      ),
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.toString().split('.').last == json['subscriptionTier'],
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'accountType': accountType.toString().split('.').last,
      'subscriptionTier': subscriptionTier.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserEntity copyWith({
    String? uid,
    String? email,
    String? name,
    AccountType? accountType,
    SubscriptionTier? subscriptionTier,
    DateTime? createdAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
