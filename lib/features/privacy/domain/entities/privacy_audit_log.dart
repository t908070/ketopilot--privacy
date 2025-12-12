import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_audit_log.freezed.dart';
part 'privacy_audit_log.g.dart';

@freezed
class PrivacyAuditLog with _$PrivacyAuditLog {
  const factory PrivacyAuditLog({
    required String id,
    required String userId,
    required AuditEventType eventType,
    required DateTime timestamp,
    required String viewerType,
    required List<String> dataScope,
    String? viewerId,
    String? sharingProfileId,
    String? sharingLinkId,
    Map<String, dynamic>? metadata,
  }) = _PrivacyAuditLog;

  factory PrivacyAuditLog.fromJson(Map<String, dynamic> json) =>
      _$PrivacyAuditLogFromJson(json);
}

enum AuditEventType {
  dataViewed,
  dataExported,
  sharingLinkCreated,
  sharingLinkAccessed,
  sharingLinkRevoked,
  profileCreated,
  profileUpdated,
  profileDeleted,
  dataShared,
}

extension AuditEventTypeExtension on AuditEventType {
  String get displayName {
    switch (this) {
      case AuditEventType.dataViewed:
        return 'Data Viewed';
      case AuditEventType.dataExported:
        return 'Data Exported';
      case AuditEventType.sharingLinkCreated:
        return 'Sharing Link Created';
      case AuditEventType.sharingLinkAccessed:
        return 'Sharing Link Accessed';
      case AuditEventType.sharingLinkRevoked:
        return 'Sharing Link Revoked';
      case AuditEventType.profileCreated:
        return 'Profile Created';
      case AuditEventType.profileUpdated:
        return 'Profile Updated';
      case AuditEventType.profileDeleted:
        return 'Profile Deleted';
      case AuditEventType.dataShared:
        return 'Data Shared';
    }
  }
}

enum ViewerType {
  user,
  doctor,
  researcher,
  community,
  system,
  external,
}

extension ViewerTypeExtension on ViewerType {
  String get displayName {
    switch (this) {
      case ViewerType.user:
        return 'User';
      case ViewerType.doctor:
        return 'Doctor';
      case ViewerType.researcher:
        return 'Researcher';
      case ViewerType.community:
        return 'Community';
      case ViewerType.system:
        return 'System';
      case ViewerType.external:
        return 'External';
    }
  }

  String get value {
    switch (this) {
      case ViewerType.user:
        return 'user';
      case ViewerType.doctor:
        return 'doctor';
      case ViewerType.researcher:
        return 'researcher';
      case ViewerType.community:
        return 'community';
      case ViewerType.system:
        return 'system';
      case ViewerType.external:
        return 'external';
    }
  }
}

