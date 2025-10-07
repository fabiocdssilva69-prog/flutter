import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'converters.dart';

part 'match_entity.freezed.dart';
part 'match_entity.g.dart';

@freezed
class MatchEntity with _$MatchEntity {
  const factory MatchEntity({
    required String matchId,
    required List<String> participants,
    @DateTimeTimestampConverter() required DateTime matchedAt,
    Map<String, dynamic>? contactInfo,
  }) = _MatchEntity;

  factory MatchEntity.fromJson(Map<String, dynamic> json) =>
      _$MatchEntityFromJson(json);
}
