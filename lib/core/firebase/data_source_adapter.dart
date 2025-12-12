import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';
import 'mock_firebase_service.dart';
import 'firebase_service.dart';
import 'dart:async';

/// 数据源适配器 - 自动在 Firebase 和本地模式之间切换
/// 
/// 这个适配器让 Repository 可以无缝使用 Firebase 或本地模式
class DataSourceAdapter {
  static bool? _isLocalMode;
  
  /// 检查是否使用本地模式
  static Future<bool> get isLocalMode async {
    _isLocalMode ??= await AppConfig.useLocalMode;
    return _isLocalMode!;
  }

  /// 设置文档（自动选择 Firebase 或本地模式）
  static Future<void> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    if (await isLocalMode) {
      await MockFirebaseService.setDocument(
        collection: collection,
        documentId: documentId,
        data: data,
      );
    } else {
      if (!FirebaseService.isInitialized) {
        throw Exception('Firebase is not initialized');
      }
      await FirebaseService.firestore
          .collection(collection)
          .doc(documentId)
          .set(data);
    }
  }

  /// 获取文档
  static Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    if (await isLocalMode) {
      return await MockFirebaseService.getDocument(
        collection: collection,
        documentId: documentId,
      );
    } else {
      if (!FirebaseService.isInitialized) {
        return null;
      }
      final doc = await FirebaseService.firestore
          .collection(collection)
          .doc(documentId)
          .get();
      
      if (!doc.exists) return null;
      return doc.data();
    }
  }

  /// 查询集合
  static Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    String? whereField,
    dynamic whereValue,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    if (await isLocalMode) {
      return await MockFirebaseService.getCollection(
        collection: collection,
        whereField: whereField,
        whereValue: whereValue,
        orderBy: orderBy,
        descending: descending,
        limit: limit,
      );
    } else {
      if (!FirebaseService.isInitialized) {
        return [];
      }
      
      Query query = FirebaseService.firestore.collection(collection);
      
      if (whereField != null && whereValue != null) {
        query = query.where(whereField, isEqualTo: whereValue);
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    }
  }

  /// 更新文档
  static Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    if (await isLocalMode) {
      await MockFirebaseService.updateDocument(
        collection: collection,
        documentId: documentId,
        data: data,
      );
    } else {
      if (!FirebaseService.isInitialized) {
        throw Exception('Firebase is not initialized');
      }
      await FirebaseService.firestore
          .collection(collection)
          .doc(documentId)
          .update(data);
    }
  }

  /// 删除文档
  static Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    if (await isLocalMode) {
      await MockFirebaseService.deleteDocument(
        collection: collection,
        documentId: documentId,
      );
    } else {
      if (!FirebaseService.isInitialized) {
        throw Exception('Firebase is not initialized');
      }
      await FirebaseService.firestore
          .collection(collection)
          .doc(documentId)
          .delete();
    }
  }

  /// 增量更新字段
  static Future<void> incrementField({
    required String collection,
    required String documentId,
    required String field,
    required int amount,
  }) async {
    if (await isLocalMode) {
      await MockFirebaseService.incrementField(
        collection: collection,
        documentId: documentId,
        field: field,
        amount: amount,
      );
    } else {
      if (!FirebaseService.isInitialized) {
        throw Exception('Firebase is not initialized');
      }
      await FirebaseService.firestore
          .collection(collection)
          .doc(documentId)
          .update({
        field: FieldValue.increment(amount),
      });
    }
  }

  /// 监听集合变化（仅 Firebase 模式支持实时更新）
  static Stream<List<Map<String, dynamic>>> watchCollection({
    required String collection,
    String? whereField,
    dynamic whereValue,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    // 本地模式不支持实时流，返回定期轮询的流
    if (!FirebaseService.isInitialized || MockFirebaseService.isInitialized) {
      // 本地模式：定期轮询
      return Stream.periodic(const Duration(seconds: 2), (_) async {
        return await getCollection(
          collection: collection,
          whereField: whereField,
          whereValue: whereValue,
          orderBy: orderBy,
          descending: descending,
          limit: limit,
        );
      }).asyncMap((future) => future);
    }
    
    // Firebase 模式：实时流
    Query query = FirebaseService.firestore.collection(collection);
    
    if (whereField != null && whereValue != null) {
      query = query.where(whereField, isEqualTo: whereValue);
    }
    
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}



