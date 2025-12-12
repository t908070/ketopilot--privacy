import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_post.freezed.dart';
part 'community_post.g.dart';

@freezed
class CommunityPost with _$CommunityPost {
  const factory CommunityPost({
    required String id,
    required String userId,
    required String alias,
    required String content,
    required PostType postType,
    required DateTime createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0.0) double sentimentScore,
    Map<String, dynamic>? metadata,
  }) = _CommunityPost;

  factory CommunityPost.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostFromJson(json);
}

enum PostType {
  progressNote,
  photo,
  motivationalQuote,
  question,
  achievement,
}

extension PostTypeExtension on PostType {
  String get displayName {
    switch (this) {
      case PostType.progressNote:
        return 'Progress Note';
      case PostType.photo:
        return 'Photo';
      case PostType.motivationalQuote:
        return 'Motivational Quote';
      case PostType.question:
        return 'Question';
      case PostType.achievement:
        return 'Achievement';
    }
  }

  String get icon {
    switch (this) {
      case PostType.progressNote:
        return '📝';
      case PostType.photo:
        return '📷';
      case PostType.motivationalQuote:
        return '💪';
      case PostType.question:
        return '❓';
      case PostType.achievement:
        return '🏆';
    }
  }
}




