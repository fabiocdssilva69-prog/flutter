import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'converters.dart';
import 'enums.dart';

part 'profile_entity.freezed.dart';
part 'profile_entity.g.dart';

@freezed
class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String profileId,
    required AccountType accountType,
    required String name,
    String? bio,
    required String city,
    required String neighborhood,
    List<String>? specialties,
    List<String>? portfolioUrls,
    List<String>? amenities,
    List<String>? galleryUrls,
  }) = _ProfileEntity;

  factory ProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileEntityFromJson(json);
}
