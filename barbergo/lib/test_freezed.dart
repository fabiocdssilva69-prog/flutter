import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_freezed.freezed.dart';
part 'test_freezed.g.dart';

@freezed
class TestEntity with _$TestEntity {
  const factory TestEntity({required String id, required String name}) = _TestEntity;

  factory TestEntity.fromJson(Map<String, dynamic> json) => _$TestEntityFromJson(json);
}
