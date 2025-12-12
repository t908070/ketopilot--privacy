// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrivacyAuditLog _$PrivacyAuditLogFromJson(Map<String, dynamic> json) {
  return _PrivacyAuditLog.fromJson(json);
}

/// @nodoc
mixin _$PrivacyAuditLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  AuditEventType get eventType => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String get viewerType => throw _privateConstructorUsedError;
  List<String> get dataScope => throw _privateConstructorUsedError;
  String? get viewerId => throw _privateConstructorUsedError;
  String? get sharingProfileId => throw _privateConstructorUsedError;
  String? get sharingLinkId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PrivacyAuditLogCopyWith<PrivacyAuditLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacyAuditLogCopyWith<$Res> {
  factory $PrivacyAuditLogCopyWith(
          PrivacyAuditLog value, $Res Function(PrivacyAuditLog) then) =
      _$PrivacyAuditLogCopyWithImpl<$Res, PrivacyAuditLog>;
  @useResult
  $Res call(
      {String id,
      String userId,
      AuditEventType eventType,
      DateTime timestamp,
      String viewerType,
      List<String> dataScope,
      String? viewerId,
      String? sharingProfileId,
      String? sharingLinkId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$PrivacyAuditLogCopyWithImpl<$Res, $Val extends PrivacyAuditLog>
    implements $PrivacyAuditLogCopyWith<$Res> {
  _$PrivacyAuditLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? eventType = null,
    Object? timestamp = null,
    Object? viewerType = null,
    Object? dataScope = null,
    Object? viewerId = freezed,
    Object? sharingProfileId = freezed,
    Object? sharingLinkId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as AuditEventType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      viewerType: null == viewerType
          ? _value.viewerType
          : viewerType // ignore: cast_nullable_to_non_nullable
              as String,
      dataScope: null == dataScope
          ? _value.dataScope
          : dataScope // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewerId: freezed == viewerId
          ? _value.viewerId
          : viewerId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharingProfileId: freezed == sharingProfileId
          ? _value.sharingProfileId
          : sharingProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharingLinkId: freezed == sharingLinkId
          ? _value.sharingLinkId
          : sharingLinkId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacyAuditLogImplCopyWith<$Res>
    implements $PrivacyAuditLogCopyWith<$Res> {
  factory _$$PrivacyAuditLogImplCopyWith(_$PrivacyAuditLogImpl value,
          $Res Function(_$PrivacyAuditLogImpl) then) =
      __$$PrivacyAuditLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      AuditEventType eventType,
      DateTime timestamp,
      String viewerType,
      List<String> dataScope,
      String? viewerId,
      String? sharingProfileId,
      String? sharingLinkId,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$PrivacyAuditLogImplCopyWithImpl<$Res>
    extends _$PrivacyAuditLogCopyWithImpl<$Res, _$PrivacyAuditLogImpl>
    implements _$$PrivacyAuditLogImplCopyWith<$Res> {
  __$$PrivacyAuditLogImplCopyWithImpl(
      _$PrivacyAuditLogImpl _value, $Res Function(_$PrivacyAuditLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? eventType = null,
    Object? timestamp = null,
    Object? viewerType = null,
    Object? dataScope = null,
    Object? viewerId = freezed,
    Object? sharingProfileId = freezed,
    Object? sharingLinkId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$PrivacyAuditLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as AuditEventType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      viewerType: null == viewerType
          ? _value.viewerType
          : viewerType // ignore: cast_nullable_to_non_nullable
              as String,
      dataScope: null == dataScope
          ? _value._dataScope
          : dataScope // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewerId: freezed == viewerId
          ? _value.viewerId
          : viewerId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharingProfileId: freezed == sharingProfileId
          ? _value.sharingProfileId
          : sharingProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      sharingLinkId: freezed == sharingLinkId
          ? _value.sharingLinkId
          : sharingLinkId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacyAuditLogImpl implements _PrivacyAuditLog {
  const _$PrivacyAuditLogImpl(
      {required this.id,
      required this.userId,
      required this.eventType,
      required this.timestamp,
      required this.viewerType,
      required final List<String> dataScope,
      this.viewerId,
      this.sharingProfileId,
      this.sharingLinkId,
      final Map<String, dynamic>? metadata})
      : _dataScope = dataScope,
        _metadata = metadata;

  factory _$PrivacyAuditLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacyAuditLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final AuditEventType eventType;
  @override
  final DateTime timestamp;
  @override
  final String viewerType;
  final List<String> _dataScope;
  @override
  List<String> get dataScope {
    if (_dataScope is EqualUnmodifiableListView) return _dataScope;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataScope);
  }

  @override
  final String? viewerId;
  @override
  final String? sharingProfileId;
  @override
  final String? sharingLinkId;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PrivacyAuditLog(id: $id, userId: $userId, eventType: $eventType, timestamp: $timestamp, viewerType: $viewerType, dataScope: $dataScope, viewerId: $viewerId, sharingProfileId: $sharingProfileId, sharingLinkId: $sharingLinkId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacyAuditLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.viewerType, viewerType) ||
                other.viewerType == viewerType) &&
            const DeepCollectionEquality()
                .equals(other._dataScope, _dataScope) &&
            (identical(other.viewerId, viewerId) ||
                other.viewerId == viewerId) &&
            (identical(other.sharingProfileId, sharingProfileId) ||
                other.sharingProfileId == sharingProfileId) &&
            (identical(other.sharingLinkId, sharingLinkId) ||
                other.sharingLinkId == sharingLinkId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      eventType,
      timestamp,
      viewerType,
      const DeepCollectionEquality().hash(_dataScope),
      viewerId,
      sharingProfileId,
      sharingLinkId,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacyAuditLogImplCopyWith<_$PrivacyAuditLogImpl> get copyWith =>
      __$$PrivacyAuditLogImplCopyWithImpl<_$PrivacyAuditLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacyAuditLogImplToJson(
      this,
    );
  }
}

abstract class _PrivacyAuditLog implements PrivacyAuditLog {
  const factory _PrivacyAuditLog(
      {required final String id,
      required final String userId,
      required final AuditEventType eventType,
      required final DateTime timestamp,
      required final String viewerType,
      required final List<String> dataScope,
      final String? viewerId,
      final String? sharingProfileId,
      final String? sharingLinkId,
      final Map<String, dynamic>? metadata}) = _$PrivacyAuditLogImpl;

  factory _PrivacyAuditLog.fromJson(Map<String, dynamic> json) =
      _$PrivacyAuditLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  AuditEventType get eventType;
  @override
  DateTime get timestamp;
  @override
  String get viewerType;
  @override
  List<String> get dataScope;
  @override
  String? get viewerId;
  @override
  String? get sharingProfileId;
  @override
  String? get sharingLinkId;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$PrivacyAuditLogImplCopyWith<_$PrivacyAuditLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
