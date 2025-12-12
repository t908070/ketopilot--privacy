import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/sharing_link.dart';

class SharingLinkRepository {
  FirebaseFirestore? get _firestore {
    if (!FirebaseService.isInitialized) return null;
    try {
      return FirebaseService.firestore;
    } catch (e) {
      return null;
    }
  }
  final _uuid = const Uuid();

  Future<SharingLink> createSharingLink({
    required String userId,
    required List<String> sharedMetrics,
    required SummaryType summaryType,
    required int expirationDays,
  }) async {
    final id = _uuid.v4();
    final token = _uuid.v4();
    final expiresAt = DateTime.now().add(Duration(days: expirationDays));
    final linkUrl = 'https://ketolink.app/share/$token';

    final link = SharingLink(
      id: id,
      userId: userId,
      token: token,
      linkUrl: linkUrl,
      expiresAt: expiresAt,
      createdAt: DateTime.now(),
      sharedMetrics: sharedMetrics,
      summaryType: summaryType.value,
    );

    final json = link.toJson();
    json['expiresAt'] = Timestamp.fromDate(link.expiresAt);
    json['createdAt'] = Timestamp.fromDate(link.createdAt);
    if (link.revokedAt != null) {
      json['revokedAt'] = Timestamp.fromDate(link.revokedAt!);
    }
    
    if (MockFirebaseService.isInitialized) {
      json['expiresAt'] = link.expiresAt.toIso8601String();
      json['createdAt'] = link.createdAt.toIso8601String();
      if (link.revokedAt != null) {
        json['revokedAt'] = link.revokedAt!.toIso8601String();
      }
      
      await MockFirebaseService.setDocument(
        collection: AppConstants.firestoreSharingLinksCollection,
        documentId: id,
        data: json,
      );
      return link;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot create link.');
      return link;
    }
    await _firestore!
        .collection(AppConstants.firestoreSharingLinksCollection)
        .doc(id)
        .set(json);

    return link;
  }

  Future<SharingLink?> getSharingLinkByToken(String token) async {
    if (MockFirebaseService.isInitialized) {
      final links = await MockFirebaseService.getCollection(
        collection: AppConstants.firestoreSharingLinksCollection,
        whereField: 'token',
        whereValue: token,
        limit: 1,
      );
      if (links.isEmpty) return null;
      return SharingLink.fromJson(links.first);
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot get link.');
      return null;
    }
    final snapshot = await _firestore!
        .collection(AppConstants.firestoreSharingLinksCollection)
        .where('token', isEqualTo: token)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data() as Map<String, dynamic>;
    // Convert Firestore Timestamps to DateTime
    if (data['expiresAt'] is Timestamp) {
      data['expiresAt'] = (data['expiresAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['revokedAt'] is Timestamp) {
      data['revokedAt'] = (data['revokedAt'] as Timestamp).toDate().toIso8601String();
    }
    return SharingLink.fromJson(data);
  }

  Future<List<SharingLink>> getSharingLinks(String userId) async {
    if (MockFirebaseService.isInitialized) {
      final docs = await MockFirebaseService.getCollection(
        collection: AppConstants.firestoreSharingLinksCollection,
        whereField: 'userId',
        whereValue: userId,
        orderBy: 'createdAt',
        descending: true,
      );
      return docs.map((data) => SharingLink.fromJson(data)).toList();
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty links.');
      return [];
    }
    final snapshot = await _firestore!
        .collection(AppConstants.firestoreSharingLinksCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Convert Firestore Timestamps to DateTime
      if (data['expiresAt'] is Timestamp) {
        data['expiresAt'] = (data['expiresAt'] as Timestamp).toDate().toIso8601String();
      }
      if (data['createdAt'] is Timestamp) {
        data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
      }
      if (data['revokedAt'] is Timestamp) {
        data['revokedAt'] = (data['revokedAt'] as Timestamp).toDate().toIso8601String();
      }
      return SharingLink.fromJson(data);
    }).toList();
  }

  Future<void> revokeSharingLink(String linkId) async {
    if (MockFirebaseService.isInitialized) {
      await MockFirebaseService.updateDocument(
        collection: AppConstants.firestoreSharingLinksCollection,
        documentId: linkId,
        data: {
          'isRevoked': true,
          'revokedAt': DateTime.now().toIso8601String(),
        },
      );
      return;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot revoke link.');
      return;
    }
    await _firestore!
        .collection(AppConstants.firestoreSharingLinksCollection)
        .doc(linkId)
        .update({
      'isRevoked': true,
      'revokedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<bool> validateSharingLink(String token) async {
    final link = await getSharingLinkByToken(token);
    if (link == null) return false;
    if (link.isRevoked) return false;
    if (link.expiresAt.isBefore(DateTime.now())) return false;
    return true;
  }

  Stream<List<SharingLink>> watchSharingLinks(String userId) {
    if (MockFirebaseService.isInitialized) {
      return Stream.fromFuture(getSharingLinks(userId));
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty stream.');
      return Stream.value([]);
    }
    return _firestore!
        .collection(AppConstants.firestoreSharingLinksCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // Convert Firestore Timestamps to DateTime
          if (data['expiresAt'] is Timestamp) {
            data['expiresAt'] = (data['expiresAt'] as Timestamp).toDate().toIso8601String();
          }
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          if (data['revokedAt'] is Timestamp) {
            data['revokedAt'] = (data['revokedAt'] as Timestamp).toDate().toIso8601String();
          }
          return SharingLink.fromJson(data);
        }).toList());
  }
}

