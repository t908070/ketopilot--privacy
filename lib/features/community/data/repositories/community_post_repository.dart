import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/community_post.dart';

class CommunityPostRepository {
  FirebaseFirestore? get _firestore {
    if (!FirebaseService.isInitialized) return null;
    try {
      return FirebaseService.firestore;
    } catch (e) {
      return null;
    }
  }
  final _uuid = const Uuid();

  String _generateAlias(String userId) {
    // Generate a randomized alias like "User#201"
    final hash = userId.hashCode.abs();
    return 'User#$hash';
  }

  Future<CommunityPost> createPost({
    required String userId,
    required String content,
    required PostType postType,
    List<String>? imageUrls,
    double? sentimentScore,
  }) async {
    final id = _uuid.v4();
    final alias = _generateAlias(userId);

    final post = CommunityPost(
      id: id,
      userId: userId,
      alias: alias,
      content: content,
      postType: postType,
      createdAt: DateTime.now(),
      imageUrls: imageUrls,
      sentimentScore: sentimentScore ?? 0.0,
    );

    final json = post.toJson();
    json['createdAt'] = Timestamp.fromDate(post.createdAt);
    if (post.updatedAt != null) {
      json['updatedAt'] = Timestamp.fromDate(post.updatedAt!);
    }
    
    if (MockFirebaseService.isInitialized) {
      json['createdAt'] = post.createdAt.toIso8601String();
      if (post.updatedAt != null) {
        json['updatedAt'] = post.updatedAt!.toIso8601String();
      }
      
      await MockFirebaseService.setDocument(
        collection: AppConstants.firestoreCommunityPostsCollection,
        documentId: id,
        data: json,
      );
      return post;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot create post.');
      return post;
    }
    await _firestore!
        .collection(AppConstants.firestoreCommunityPostsCollection)
        .doc(id)
        .set(json);

    return post;
  }

  Future<List<CommunityPost>> getRecentPosts({int limit = 20}) async {
    if (MockFirebaseService.isInitialized) {
      final docs = await MockFirebaseService.getCollection(
        collection: AppConstants.firestoreCommunityPostsCollection,
        orderBy: 'createdAt',
        descending: true,
        limit: limit,
      );
      return docs.map((data) => CommunityPost.fromJson(data)).toList();
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty posts.');
      return [];
    }
    final snapshot = await _firestore!
        .collection(AppConstants.firestoreCommunityPostsCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Convert Firestore Timestamps to DateTime
      if (data['createdAt'] is Timestamp) {
        data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
      }
      if (data['updatedAt'] is Timestamp) {
        data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
      }
      return CommunityPost.fromJson(data);
    }).toList();
  }

  Future<void> likePost(String postId) async {
    if (MockFirebaseService.isInitialized) {
      await MockFirebaseService.incrementField(
        collection: AppConstants.firestoreCommunityPostsCollection,
        documentId: postId,
        field: 'likes',
        amount: 1,
      );
      return;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot like post.');
      return;
    }
    await _firestore!
        .collection(AppConstants.firestoreCommunityPostsCollection)
        .doc(postId)
        .update({
      'likes': FieldValue.increment(1),
    });
  }

  Future<void> updateSentimentScore(String postId, double score) async {
    if (MockFirebaseService.isInitialized) {
      await MockFirebaseService.updateDocument(
        collection: AppConstants.firestoreCommunityPostsCollection,
        documentId: postId,
        data: {
          'sentimentScore': score,
        },
      );
      return;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot update sentiment.');
      return;
    }
    await _firestore!
        .collection(AppConstants.firestoreCommunityPostsCollection)
        .doc(postId)
        .update({
      'sentimentScore': score,
    });
  }

  Stream<List<CommunityPost>> watchRecentPosts({int limit = 20}) {
    if (MockFirebaseService.isInitialized) {
      return Stream.fromFuture(getRecentPosts(limit: limit));
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty stream.');
      return Stream.value([]);
    }
    return _firestore!
        .collection(AppConstants.firestoreCommunityPostsCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // Convert Firestore Timestamps to DateTime
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          if (data['updatedAt'] is Timestamp) {
            data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
          }
          return CommunityPost.fromJson(data);
        }).toList());
  }
}

