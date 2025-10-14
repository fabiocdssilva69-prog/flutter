import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converters.dart'; // Importa o conversor centralizado
import 'enums.dart';

part 'profile_entity.freezed.dart';
part 'profile_entity.g.dart';

@freezed
class ProfileEntity with _$ProfileEntity {
  // explicitToJson é crucial quando usamos conversores customizados (TimestampConverter)
  @JsonSerializable(explicitToJson: true)
  const factory ProfileEntity({
    required String userId,
    required AccountType accountType,
    required String name,
    required String email,

    @Default('') String bio,
    @Default('') String location,
    @Default('') String contactPhone,

    String? fcmToken,

    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _ProfileEntity;

  factory ProfileEntity.fromJson(Map<String, dynamic> json) => _$ProfileEntityFromJson(json);
}
