import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../domain/entities/community_post.dart';
import '../providers/community_providers.dart';

@RoutePage()
class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(recentPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePostDialog(context, ref),
            tooltip: 'Create Post',
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(recentPostsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return _buildPostCard(context, ref, post);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Posts Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to share your progress!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreatePostDialog(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Create Post'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, WidgetRef ref, CommunityPost post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    post.alias.substring(post.alias.length - 2),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.alias,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(post.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(post.postType.icon),
                      const SizedBox(width: 4),
                      Text(
                        post.postType.displayName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.content,
              style: const TextStyle(fontSize: 14),
            ),
            if (post.imageUrls != null && post.imageUrls!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.imageUrls!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: const Center(
                        child: Icon(Icons.image, size: 48, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () async {
                    final repository = ref.read(communityPostRepositoryProvider);
                    await repository.likePost(post.id);
                    ref.invalidate(recentPostsProvider);
                  },
                ),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined, size: 20),
                const SizedBox(width: 4),
                Text('${post.comments}'),
                const Spacer(),
                if (post.sentimentScore > 0.7)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sentiment_very_satisfied, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text('Positive', style: TextStyle(fontSize: 12, color: Colors.green)),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreatePostDialog(),
    );
  }
}

class _CreatePostDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends ConsumerState<_CreatePostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  PostType _selectedPostType = PostType.progressNote;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Post'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<PostType>(
                value: _selectedPostType,
                decoration: const InputDecoration(labelText: 'Post Type'),
                items: PostType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Text(type.icon),
                        const SizedBox(width: 8),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedPostType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Share your progress, ask a question, or motivate others...',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  if (value.length < 10) {
                    return 'Content must be at least 10 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createPost,
          child: const Text('Post'),
        ),
      ],
    );
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate()) return;

    // Ensure Mock service is initialized if we are in local mode (Safety net)
    if (!FirebaseService.isInitialized && !MockFirebaseService.isInitialized) {
      debugPrint('⚠️ MockFirebaseService not initialized, initializing now...');
      await MockFirebaseService.initialize();
    }

    // Use Firebase user ID if available, otherwise check Mock service
    final userId = FirebaseService.currentUserId ?? MockFirebaseService.currentUserId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in (or restart app) to create a post')),
      );
      return;
    }

    final repository = ref.read(communityPostRepositoryProvider);
    
    // Simple sentiment analysis (in production, use TensorFlow Lite)
    final content = _contentController.text.toLowerCase();
    double sentimentScore = 0.5; // Default neutral
    if (content.contains(RegExp(r'\b(great|excellent|amazing|wonderful|happy|proud|success)\b'))) {
      sentimentScore = 0.8;
    } else if (content.contains(RegExp(r'\b(bad|terrible|awful|sad|disappointed|failed)\b'))) {
      sentimentScore = 0.2;
    }

    await repository.createPost(
      userId: userId,
      content: _contentController.text,
      postType: _selectedPostType,
      sentimentScore: sentimentScore,
    );
    
    // Force refresh the list
    ref.invalidate(recentPostsProvider);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post created successfully!')),
    );
  }
}




