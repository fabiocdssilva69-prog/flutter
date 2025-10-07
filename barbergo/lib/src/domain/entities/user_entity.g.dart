// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
      uid: json['uid'] as String,
      email: json['email'] as String,
      accountType: $enumDecode(_$AccountTypeEnumMap, json['accountType']),
      subscriptionTier:
          $enumDecode(_$SubscriptionTierEnumMap, json['subscriptionTier']),
      createdAt: const DateTimeTimestampConverter()
          .fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'accountType': _$AccountTypeEnumMap[instance.accountType]!,
      'subscriptionTier': _$SubscriptionTierEnumMap[instance.subscriptionTier]!,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
    };

const _$AccountTypeEnumMap = {
  AccountType.barber: 'barber',
  AccountType.barbershop: 'barbershop',
};

const _$SubscriptionTierEnumMap = {
  SubscriptionTier.free: 'free',
  SubscriptionTier.premium: 'premium',
};
