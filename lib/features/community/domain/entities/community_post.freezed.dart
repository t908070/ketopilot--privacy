// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommunityPost _$CommunityPostFromJson(Map<String, dynamic> json) {
  return _CommunityPost.fromJson(json);
}

/// @nodoc
mixin _$CommunityPost {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get alias => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  PostType get postType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  int get comments => throw _privateConstructorUsedError;
  double get sentimentScore => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommunityPostCopyWith<CommunityPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityPostCopyWith<$Res> {
  factory $CommunityPostCopyWith(
          CommunityPost value, $Res Function(CommunityPost) then) =
      _$CommunityPostCopyWithImpl<$Res, CommunityPost>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String alias,
      String content,
      PostType postType,
      DateTime createdAt,
      DateTime? updatedAt,
      List<String>? imageUrls,
      int likes,
      int comments,
      double sentimentScore,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$CommunityPostCopyWithImpl<$Res, $Val extends CommunityPost>
    implements $CommunityPostCopyWith<$Res> {
  _$CommunityPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? alias = null,
    Object? content = null,
    Object? postType = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? imageUrls = freezed,
    Object? likes = null,
    Object? comments = null,
    Object? sentimentScore = null,
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
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrls: freezed == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as int,
      sentimentScore: null == sentimentScore
          ? _value.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommunityPostImplCopyWith<$Res>
    implements $CommunityPostCopyWith<$Res> {
  factory _$$CommunityPostImplCopyWith(
          _$CommunityPostImpl value, $Res Function(_$CommunityPostImpl) then) =
      __$$CommunityPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String alias,
      String content,
      PostType postType,
      DateTime createdAt,
      DateTime? updatedAt,
      List<String>? imageUrls,
      int likes,
      int comments,
      double sentimentScore,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$CommunityPostImplCopyWithImpl<$Res>
    extends _$CommunityPostCopyWithImpl<$Res, _$CommunityPostImpl>
    implements _$$CommunityPostImplCopyWith<$Res> {
  __$$CommunityPostImplCopyWithImpl(
      _$CommunityPostImpl _value, $Res Function(_$CommunityPostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? alias = null,
    Object? content = null,
    Object? postType = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? imageUrls = freezed,
    Object? likes = null,
    Object? comments = null,
    Object? sentimentScore = null,
    Object? metadata = freezed,
  }) {
    return _then(_$CommunityPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      alias: null == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrls: freezed == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as int,
      sentimentScore: null == sentimentScore
          ? _value.sentimentScore
          : sentimentScore // ignore: cast_nullable_to_non_nullable
              as double,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityPostImpl implements _CommunityPost {
  const _$CommunityPostImpl(
      {required this.id,
      required this.userId,
      required this.alias,
      required this.content,
      required this.postType,
      required this.createdAt,
      this.updatedAt,
      final List<String>? imageUrls,
      this.likes = 0,
      this.comments = 0,
      this.sentimentScore = 0.0,
      final Map<String, dynamic>? metadata})
      : _imageUrls = imageUrls,
        _metadata = metadata;

  factory _$CommunityPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityPostImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String alias;
  @override
  final String content;
  @override
  final PostType postType;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int likes;
  @override
  @JsonKey()
  final int comments;
  @override
  @JsonKey()
  final double sentimentScore;
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
    return 'CommunityPost(id: $id, userId: $userId, alias: $alias, content: $content, postType: $postType, createdAt: $createdAt, updatedAt: $updatedAt, imageUrls: $imageUrls, likes: $likes, comments: $comments, sentimentScore: $sentimentScore, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.sentimentScore, sentimentScore) ||
                other.sentimentScore == sentimentScore) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      alias,
      content,
      postType,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_imageUrls),
      likes,
      comments,
      sentimentScore,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      __$$CommunityPostImplCopyWithImpl<_$CommunityPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityPostImplToJson(
      this,
    );
  }
}

abstract class _CommunityPost implements CommunityPost {
  const factory _CommunityPost(
      {required final String id,
      required final String userId,
      required final String alias,
      required final String content,
      required final PostType postType,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final List<String>? imageUrls,
      final int likes,
      final int comments,
      final double sentimentScore,
      final Map<String, dynamic>? metadata}) = _$CommunityPostImpl;

  factory _CommunityPost.fromJson(Map<String, dynamic> json) =
      _$CommunityPostImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get alias;
  @override
  String get content;
  @override
  PostType get postType;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<String>? get imageUrls;
  @override
  int get likes;
  @override
  int get comments;
  @override
  double get sentimentScore;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
