// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SharingProfileImpl _$$SharingProfileImplFromJson(Map<String, dynamic> json) =>
    _$SharingProfileImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profileName: json['profileName'] as String,
      metrics:
          (json['metrics'] as List<dynamic>).map((e) => e as String).toList(),
      granularity: json['granularity'] as String,
      expires: DateTime.parse(json['expires'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$SharingProfileImplToJson(
        _$SharingProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileName': instance.profileName,
      'metrics': instance.metrics,
      'granularity': instance.granularity,
      'expires': instance.expires.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isActive': instance.isActive,
    };
