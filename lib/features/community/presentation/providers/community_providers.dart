import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/community_post_repository.dart';
import '../../domain/entities/community_post.dart';

final communityPostRepositoryProvider = Provider<CommunityPostRepository>((ref) {
  return CommunityPostRepository();
});

final recentPostsProvider = StreamProvider<List<CommunityPost>>((ref) {
  final repository = ref.watch(communityPostRepositoryProvider);
  return repository.watchRecentPosts(limit: 20);
});




