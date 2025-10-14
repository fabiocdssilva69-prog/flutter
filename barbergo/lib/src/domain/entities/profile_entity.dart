import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart'; // Importa o conversor centralizado
import 'enums.dart';

part 'profile_entity.freezed.dart';
part 'profile_entity.g.dart';

@freezed
abstract class ProfileEntity with _$ProfileEntity {
  const ProfileEntity._(); // Private constructor for computed properties

  const factory ProfileEntity({
    required String userId,
    required AccountType accountType,
    required String name,
    required String email,

    @Default('') String bio,
    @Default('') String location,
    @Default('') String city,
    @Default('') String neighborhood,
    @Default([]) List<String> specialties,
    @Default('') String contactPhone,

    String? fcmToken,

    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _ProfileEntity;

  factory ProfileEntity.fromJson(Map<String, dynamic> json) => _$ProfileEntityFromJson(json);

  // Computed property for displayName
  String get displayName => name;
}
