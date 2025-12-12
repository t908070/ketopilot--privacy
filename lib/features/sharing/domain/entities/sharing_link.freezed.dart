// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sharing_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SharingLink _$SharingLinkFromJson(Map<String, dynamic> json) {
  return _SharingLink.fromJson(json);
}

/// @nodoc
mixin _$SharingLink {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get linkUrl => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get revokedAt => throw _privateConstructorUsedError;
  bool get isRevoked => throw _privateConstructorUsedError;
  List<String> get sharedMetrics => throw _privateConstructorUsedError;
  String get summaryType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharingLinkCopyWith<SharingLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharingLinkCopyWith<$Res> {
  factory $SharingLinkCopyWith(
          SharingLink value, $Res Function(SharingLink) then) =
      _$SharingLinkCopyWithImpl<$Res, SharingLink>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String token,
      String linkUrl,
      DateTime expiresAt,
      DateTime createdAt,
      DateTime? revokedAt,
      bool isRevoked,
      List<String> sharedMetrics,
      String summaryType,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SharingLinkCopyWithImpl<$Res, $Val extends SharingLink>
    implements $SharingLinkCopyWith<$Res> {
  _$SharingLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? token = null,
    Object? linkUrl = null,
    Object? expiresAt = null,
    Object? createdAt = null,
    Object? revokedAt = freezed,
    Object? isRevoked = null,
    Object? sharedMetrics = null,
    Object? summaryType = null,
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
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      linkUrl: null == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revokedAt: freezed == revokedAt
          ? _value.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRevoked: null == isRevoked
          ? _value.isRevoked
          : isRevoked // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedMetrics: null == sharedMetrics
          ? _value.sharedMetrics
          : sharedMetrics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      summaryType: null == summaryType
          ? _value.summaryType
          : summaryType // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharingLinkImplCopyWith<$Res>
    implements $SharingLinkCopyWith<$Res> {
  factory _$$SharingLinkImplCopyWith(
          _$SharingLinkImpl value, $Res Function(_$SharingLinkImpl) then) =
      __$$SharingLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String token,
      String linkUrl,
      DateTime expiresAt,
      DateTime createdAt,
      DateTime? revokedAt,
      bool isRevoked,
      List<String> sharedMetrics,
      String summaryType,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$SharingLinkImplCopyWithImpl<$Res>
    extends _$SharingLinkCopyWithImpl<$Res, _$SharingLinkImpl>
    implements _$$SharingLinkImplCopyWith<$Res> {
  __$$SharingLinkImplCopyWithImpl(
      _$SharingLinkImpl _value, $Res Function(_$SharingLinkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? token = null,
    Object? linkUrl = null,
    Object? expiresAt = null,
    Object? createdAt = null,
    Object? revokedAt = freezed,
    Object? isRevoked = null,
    Object? sharedMetrics = null,
    Object? summaryType = null,
    Object? metadata = freezed,
  }) {
    return _then(_$SharingLinkImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      linkUrl: null == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      revokedAt: freezed == revokedAt
          ? _value.revokedAt
          : revokedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRevoked: null == isRevoked
          ? _value.isRevoked
          : isRevoked // ignore: cast_nullable_to_non_nullable
              as bool,
      sharedMetrics: null == sharedMetrics
          ? _value._sharedMetrics
          : sharedMetrics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      summaryType: null == summaryType
          ? _value.summaryType
          : summaryType // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharingLinkImpl implements _SharingLink {
  const _$SharingLinkImpl(
      {required this.id,
      required this.userId,
      required this.token,
      required this.linkUrl,
      required this.expiresAt,
      required this.createdAt,
      this.revokedAt,
      this.isRevoked = false,
      required final List<String> sharedMetrics,
      required this.summaryType,
      final Map<String, dynamic>? metadata})
      : _sharedMetrics = sharedMetrics,
        _metadata = metadata;

  factory _$SharingLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharingLinkImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String token;
  @override
  final String linkUrl;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? revokedAt;
  @override
  @JsonKey()
  final bool isRevoked;
  final List<String> _sharedMetrics;
  @override
  List<String> get sharedMetrics {
    if (_sharedMetrics is EqualUnmodifiableListView) return _sharedMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedMetrics);
  }

  @override
  final String summaryType;
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
    return 'SharingLink(id: $id, userId: $userId, token: $token, linkUrl: $linkUrl, expiresAt: $expiresAt, createdAt: $createdAt, revokedAt: $revokedAt, isRevoked: $isRevoked, sharedMetrics: $sharedMetrics, summaryType: $summaryType, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharingLinkImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.revokedAt, revokedAt) ||
                other.revokedAt == revokedAt) &&
            (identical(other.isRevoked, isRevoked) ||
                other.isRevoked == isRevoked) &&
            const DeepCollectionEquality()
                .equals(other._sharedMetrics, _sharedMetrics) &&
            (identical(other.summaryType, summaryType) ||
                other.summaryType == summaryType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      token,
      linkUrl,
      expiresAt,
      createdAt,
      revokedAt,
      isRevoked,
      const DeepCollectionEquality().hash(_sharedMetrics),
      summaryType,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharingLinkImplCopyWith<_$SharingLinkImpl> get copyWith =>
      __$$SharingLinkImplCopyWithImpl<_$SharingLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharingLinkImplToJson(
      this,
    );
  }
}

abstract class _SharingLink implements SharingLink {
  const factory _SharingLink(
      {required final String id,
      required final String userId,
      required final String token,
      required final String linkUrl,
      required final DateTime expiresAt,
      required final DateTime createdAt,
      final DateTime? revokedAt,
      final bool isRevoked,
      required final List<String> sharedMetrics,
      required final String summaryType,
      final Map<String, dynamic>? metadata}) = _$SharingLinkImpl;

  factory _SharingLink.fromJson(Map<String, dynamic> json) =
      _$SharingLinkImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get token;
  @override
  String get linkUrl;
  @override
  DateTime get expiresAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get revokedAt;
  @override
  bool get isRevoked;
  @override
  List<String> get sharedMetrics;
  @override
  String get summaryType;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$SharingLinkImplCopyWith<_$SharingLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
