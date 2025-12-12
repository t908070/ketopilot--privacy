// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityPostImpl _$$CommunityPostImplFromJson(Map<String, dynamic> json) =>
    _$CommunityPostImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      alias: json['alias'] as String,
      content: json['content'] as String,
      postType: $enumDecode(_$PostTypeEnumMap, json['postType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      sentimentScore: (json['sentimentScore'] as num?)?.toDouble() ?? 0.0,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CommunityPostImplToJson(_$CommunityPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'alias': instance.alias,
      'content': instance.content,
      'postType': _$PostTypeEnumMap[instance.postType]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'imageUrls': instance.imageUrls,
      'likes': instance.likes,
      'comments': instance.comments,
      'sentimentScore': instance.sentimentScore,
      'metadata': instance.metadata,
    };

const _$PostTypeEnumMap = {
  PostType.progressNote: 'progressNote',
  PostType.photo: 'photo',
  PostType.motivationalQuote: 'motivationalQuote',
  PostType.question: 'question',
  PostType.achievement: 'achievement',
};
