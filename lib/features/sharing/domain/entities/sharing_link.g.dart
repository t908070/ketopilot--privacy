// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SharingLinkImpl _$$SharingLinkImplFromJson(Map<String, dynamic> json) =>
    _$SharingLinkImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String,
      linkUrl: json['linkUrl'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      revokedAt: json['revokedAt'] == null
          ? null
          : DateTime.parse(json['revokedAt'] as String),
      isRevoked: json['isRevoked'] as bool? ?? false,
      sharedMetrics: (json['sharedMetrics'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      summaryType: json['summaryType'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SharingLinkImplToJson(_$SharingLinkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'token': instance.token,
      'linkUrl': instance.linkUrl,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'revokedAt': instance.revokedAt?.toIso8601String(),
      'isRevoked': instance.isRevoked,
      'sharedMetrics': instance.sharedMetrics,
      'summaryType': instance.summaryType,
      'metadata': instance.metadata,
    };
