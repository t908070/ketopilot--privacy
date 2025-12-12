// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivacyAuditLogImpl _$$PrivacyAuditLogImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacyAuditLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      eventType: $enumDecode(_$AuditEventTypeEnumMap, json['eventType']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      viewerType: json['viewerType'] as String,
      dataScope:
          (json['dataScope'] as List<dynamic>).map((e) => e as String).toList(),
      viewerId: json['viewerId'] as String?,
      sharingProfileId: json['sharingProfileId'] as String?,
      sharingLinkId: json['sharingLinkId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PrivacyAuditLogImplToJson(
        _$PrivacyAuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'eventType': _$AuditEventTypeEnumMap[instance.eventType]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'viewerType': instance.viewerType,
      'dataScope': instance.dataScope,
      'viewerId': instance.viewerId,
      'sharingProfileId': instance.sharingProfileId,
      'sharingLinkId': instance.sharingLinkId,
      'metadata': instance.metadata,
    };

const _$AuditEventTypeEnumMap = {
  AuditEventType.dataViewed: 'dataViewed',
  AuditEventType.dataExported: 'dataExported',
  AuditEventType.sharingLinkCreated: 'sharingLinkCreated',
  AuditEventType.sharingLinkAccessed: 'sharingLinkAccessed',
  AuditEventType.sharingLinkRevoked: 'sharingLinkRevoked',
  AuditEventType.profileCreated: 'profileCreated',
  AuditEventType.profileUpdated: 'profileUpdated',
  AuditEventType.profileDeleted: 'profileDeleted',
  AuditEventType.dataShared: 'dataShared',
};
