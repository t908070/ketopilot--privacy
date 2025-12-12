// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sharing_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SharingProfile _$SharingProfileFromJson(Map<String, dynamic> json) {
  return _SharingProfile.fromJson(json);
}

/// @nodoc
mixin _$SharingProfile {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get profileName => throw _privateConstructorUsedError;
  List<String> get metrics => throw _privateConstructorUsedError;
  String get granularity => throw _privateConstructorUsedError;
  DateTime get expires => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharingProfileCopyWith<SharingProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharingProfileCopyWith<$Res> {
  factory $SharingProfileCopyWith(
          SharingProfile value, $Res Function(SharingProfile) then) =
      _$SharingProfileCopyWithImpl<$Res, SharingProfile>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileName,
      List<String> metrics,
      String granularity,
      DateTime expires,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isActive});
}

/// @nodoc
class _$SharingProfileCopyWithImpl<$Res, $Val extends SharingProfile>
    implements $SharingProfileCopyWith<$Res> {
  _$SharingProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileName = null,
    Object? metrics = null,
    Object? granularity = null,
    Object? expires = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
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
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
      metrics: null == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      granularity: null == granularity
          ? _value.granularity
          : granularity // ignore: cast_nullable_to_non_nullable
              as String,
      expires: null == expires
          ? _value.expires
          : expires // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharingProfileImplCopyWith<$Res>
    implements $SharingProfileCopyWith<$Res> {
  factory _$$SharingProfileImplCopyWith(_$SharingProfileImpl value,
          $Res Function(_$SharingProfileImpl) then) =
      __$$SharingProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileName,
      List<String> metrics,
      String granularity,
      DateTime expires,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isActive});
}

/// @nodoc
class __$$SharingProfileImplCopyWithImpl<$Res>
    extends _$SharingProfileCopyWithImpl<$Res, _$SharingProfileImpl>
    implements _$$SharingProfileImplCopyWith<$Res> {
  __$$SharingProfileImplCopyWithImpl(
      _$SharingProfileImpl _value, $Res Function(_$SharingProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileName = null,
    Object? metrics = null,
    Object? granularity = null,
    Object? expires = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$SharingProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
      metrics: null == metrics
          ? _value._metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      granularity: null == granularity
          ? _value.granularity
          : granularity // ignore: cast_nullable_to_non_nullable
              as String,
      expires: null == expires
          ? _value.expires
          : expires // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharingProfileImpl implements _SharingProfile {
  const _$SharingProfileImpl(
      {required this.id,
      required this.userId,
      required this.profileName,
      required final List<String> metrics,
      required this.granularity,
      required this.expires,
      required this.createdAt,
      this.updatedAt,
      this.isActive = false})
      : _metrics = metrics;

  factory _$SharingProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharingProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String profileName;
  final List<String> _metrics;
  @override
  List<String> get metrics {
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metrics);
  }

  @override
  final String granularity;
  @override
  final DateTime expires;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'SharingProfile(id: $id, userId: $userId, profileName: $profileName, metrics: $metrics, granularity: $granularity, expires: $expires, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharingProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics) &&
            (identical(other.granularity, granularity) ||
                other.granularity == granularity) &&
            (identical(other.expires, expires) || other.expires == expires) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      profileName,
      const DeepCollectionEquality().hash(_metrics),
      granularity,
      expires,
      createdAt,
      updatedAt,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharingProfileImplCopyWith<_$SharingProfileImpl> get copyWith =>
      __$$SharingProfileImplCopyWithImpl<_$SharingProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharingProfileImplToJson(
      this,
    );
  }
}

abstract class _SharingProfile implements SharingProfile {
  const factory _SharingProfile(
      {required final String id,
      required final String userId,
      required final String profileName,
      required final List<String> metrics,
      required final String granularity,
      required final DateTime expires,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final bool isActive}) = _$SharingProfileImpl;

  factory _SharingProfile.fromJson(Map<String, dynamic> json) =
      _$SharingProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get profileName;
  @override
  List<String> get metrics;
  @override
  String get granularity;
  @override
  DateTime get expires;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$SharingProfileImplCopyWith<_$SharingProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
