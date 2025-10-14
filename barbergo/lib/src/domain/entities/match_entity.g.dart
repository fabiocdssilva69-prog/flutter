// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MatchEntity _$MatchEntityFromJson(Map<String, dynamic> json) => _MatchEntity(
  matchId: json['matchId'] as String,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  matchedAt: const TimestampConverter().fromJson(
    json['matchedAt'] as Timestamp,
  ),
  contactInfo: json['contactInfo'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MatchEntityToJson(_MatchEntity instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'participants': instance.participants,
      'matchedAt': const TimestampConverter().toJson(instance.matchedAt),
      'contactInfo': instance.contactInfo,
    };
