import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/privacy_audit_log.dart';

class PrivacyAuditRepository {
  FirebaseFirestore? get _firestore {
    if (!FirebaseService.isInitialized) return null;
    try {
      return FirebaseService.firestore;
    } catch (e) {
      return null;
    }
  }
  final _uuid = const Uuid();

  Future<void> logEvent(PrivacyAuditLog log) async {
    final json = log.toJson();
    json['timestamp'] = Timestamp.fromDate(log.timestamp);

    if (MockFirebaseService.isInitialized) {
      // 本地测试模式
      // Convert Timestamp to ISO string for mock storage
      json['timestamp'] = log.timestamp.toIso8601String();
      await MockFirebaseService.setDocument(
        collection: AppConstants.firestorePrivacyAuditCollection,
        documentId: log.id,
        data: json,
      );
      return;
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Cannot log event.');
      return;
    }
    
    await _firestore!
        .collection(AppConstants.firestorePrivacyAuditCollection)
        .doc(log.id)
        .set(json);
  }

  Future<void> logDataAccess({
    required String userId,
    required ViewerType viewerType,
    required List<String> dataScope,
    String? viewerId,
    String? sharingProfileId,
    String? sharingLinkId,
  }) async {
    final log = PrivacyAuditLog(
      id: _uuid.v4(),
      userId: userId,
      eventType: AuditEventType.dataViewed,
      timestamp: DateTime.now(),
      viewerType: viewerType.value,
      dataScope: dataScope,
      viewerId: viewerId,
      sharingProfileId: sharingProfileId,
      sharingLinkId: sharingLinkId,
    );

    await logEvent(log);
  }

  Future<List<PrivacyAuditLog>> getAuditLogs(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    if (MockFirebaseService.isInitialized) {
      // 本地测试模式
      var docs = await MockFirebaseService.getCollection(
        collection: AppConstants.firestorePrivacyAuditCollection,
        whereField: 'userId',
        whereValue: userId,
        orderBy: 'timestamp',
        descending: true,
      );

      // Manual filtering for dates since mock service only supports basic queries
      if (startDate != null) {
        docs = docs.where((doc) {
          final ts = DateTime.parse(doc['timestamp']);
          return ts.isAfter(startDate) || ts.isAtSameMomentAs(startDate);
        }).toList();
      }
      if (endDate != null) {
        docs = docs.where((doc) {
          final ts = DateTime.parse(doc['timestamp']);
          return ts.isBefore(endDate) || ts.isAtSameMomentAs(endDate);
        }).toList();
      }
      
      if (limit != null && docs.length > limit) {
        docs = docs.take(limit).toList();
      }

      return docs.map((data) => PrivacyAuditLog.fromJson(data)).toList();
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty audit logs.');
      return [];
    }
    Query query = _firestore!
        .collection(AppConstants.firestorePrivacyAuditCollection)
        .where('userId', isEqualTo: userId);

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    query = query.orderBy('timestamp', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Convert Firestore Timestamps to DateTime
      if (data['timestamp'] is Timestamp) {
        data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
      }
      return PrivacyAuditLog.fromJson(data);
    }).toList();
  }

  Stream<List<PrivacyAuditLog>> watchAuditLogs(String userId, {int? limit}) {
    if (MockFirebaseService.isInitialized) {
      // Local mode: return a single-emit stream from the future
      return Stream.fromFuture(getAuditLogs(userId, limit: limit));
    }

    if (_firestore == null) {
      print('⚠️ Firebase not initialized. Returning empty stream.');
      return Stream.value([]);
    }
    Query query = _firestore!
        .collection(AppConstants.firestorePrivacyAuditCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Convert Firestore Timestamps to DateTime
      if (data['timestamp'] is Timestamp) {
        data['timestamp'] = (data['timestamp'] as Timestamp).toDate().toIso8601String();
      }
      return PrivacyAuditLog.fromJson(data);
    }).toList());
  }

  Future<Map<String, int>> getAccessSummary(String userId) async {
    final logs = await getAuditLogs(userId);
    final summary = <String, int>{};

    for (final log in logs) {
      final key = log.viewerType;
      summary[key] = (summary[key] ?? 0) + 1;
    }

    return summary;
  }
}

