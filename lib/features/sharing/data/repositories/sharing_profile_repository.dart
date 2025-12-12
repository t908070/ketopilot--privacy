import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/sharing_profile.dart';

class SharingProfileRepository {
  FirebaseFirestore? get _firestore {
    if (!FirebaseService.isInitialized) return null;
    try {
      return FirebaseService.firestore;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveSharingProfile(SharingProfile profile) async {
    final json = profile.toJson();
    // Convert DateTime to Timestamp for Firestore
    json['expires'] = Timestamp.fromDate(profile.expires);
    json['createdAt'] = Timestamp.fromDate(profile.createdAt);
    if (profile.updatedAt != null) {
      json['updatedAt'] = Timestamp.fromDate(profile.updatedAt!);
    }
    
    if (MockFirebaseService.isInitialized) {
      // Local mode
      json['expires'] = profile.expires.toIso8601String();
      json['createdAt'] = profile.createdAt.toIso8601String();
      if (profile.updatedAt != null) {
        json['updatedAt'] = profile.updatedAt!.toIso8601String();
      }
      
      await MockFirebaseService.setDocument(
        collection: AppConstants.firestoreSharingProfilesCollection,
        documentId: profile.id,
        data: json,
      );
      return;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot save profile.');
      return;
    }
    
    await _firestore!
        .collection(AppConstants.firestoreSharingProfilesCollection)
        .doc(profile.id)
        .set(json);
  }

  Future<List<SharingProfile>> getSharingProfiles(String userId) async {
    if (MockFirebaseService.isInitialized) {
      final docs = await MockFirebaseService.getCollection(
        collection: AppConstants.firestoreSharingProfilesCollection,
        whereField: 'userId',
        whereValue: userId,
        orderBy: 'createdAt',
        descending: true,
      );
      return docs.map((data) => SharingProfile.fromJson(data)).toList();
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty profiles.');
      return [];
    }
    final snapshot = await _firestore!
        .collection(AppConstants.firestoreSharingProfilesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      // Convert Firestore Timestamps to DateTime
      if (data['expires'] is Timestamp) {
        data['expires'] = (data['expires'] as Timestamp).toDate().toIso8601String();
      }
      if (data['createdAt'] is Timestamp) {
        data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
      }
      if (data['updatedAt'] is Timestamp) {
        data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
      }
      return SharingProfile.fromJson(data);
    }).toList();
  }

  Future<SharingProfile?> getSharingProfile(String profileId) async {
    if (MockFirebaseService.isInitialized) {
      final data = await MockFirebaseService.getDocument(
        collection: AppConstants.firestoreSharingProfilesCollection,
        documentId: profileId,
      );
      if (data == null) return null;
      return SharingProfile.fromJson(data);
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot get profile.');
      return null;
    }
    final doc = await _firestore!
        .collection(AppConstants.firestoreSharingProfilesCollection)
        .doc(profileId)
        .get();

    if (!doc.exists) return null;
    final data = doc.data()!;
    // Convert Firestore Timestamps to DateTime
    if (data['expires'] is Timestamp) {
      data['expires'] = (data['expires'] as Timestamp).toDate().toIso8601String();
    }
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
    }
    return SharingProfile.fromJson(data);
  }

  Future<void> updateSharingProfile(SharingProfile profile) async {
    final json = profile.toJson();
    json['expires'] = Timestamp.fromDate(profile.expires);
    json['createdAt'] = Timestamp.fromDate(profile.createdAt);
    json['updatedAt'] = Timestamp.fromDate(DateTime.now());
    
    if (MockFirebaseService.isInitialized) {
      // Local mode
      json['expires'] = profile.expires.toIso8601String();
      json['createdAt'] = profile.createdAt.toIso8601String();
      json['updatedAt'] = DateTime.now().toIso8601String();
      
      await MockFirebaseService.updateDocument(
        collection: AppConstants.firestoreSharingProfilesCollection,
        documentId: profile.id,
        data: json,
      );
      return;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot update profile.');
      return;
    }
    
    await _firestore!
        .collection(AppConstants.firestoreSharingProfilesCollection)
        .doc(profile.id)
        .update(json);
  }

  Future<void> deleteSharingProfile(String profileId) async {
    print('🗑️ Deleting profile: $profileId (Local mode: ${MockFirebaseService.isInitialized})');
    if (MockFirebaseService.isInitialized) {
      await MockFirebaseService.deleteDocument(
        collection: AppConstants.firestoreSharingProfilesCollection,
        documentId: profileId,
      );
      return;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot delete profile.');
      return;
    }
    await _firestore!
        .collection(AppConstants.firestoreSharingProfilesCollection)
        .doc(profileId)
        .delete();
  }

  Stream<List<SharingProfile>> watchSharingProfiles(String userId) {
    if (MockFirebaseService.isInitialized) {
      return Stream.fromFuture(getSharingProfiles(userId));
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty stream.');
      return Stream.value([]);
    }
    return _firestore!
        .collection(AppConstants.firestoreSharingProfilesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          // Convert Firestore Timestamps to DateTime
          if (data['expires'] is Timestamp) {
            data['expires'] = (data['expires'] as Timestamp).toDate().toIso8601String();
          }
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          if (data['updatedAt'] is Timestamp) {
            data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
          }
          return SharingProfile.fromJson(data);
        }).toList());
  }
}

