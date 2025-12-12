import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import '../config/app_config.dart';
import '../database/local_database_service.dart';
import '../database/web_storage_service.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

/// Mock Firebase Service - 用于本地测试
/// 
/// 这个服务模拟 Firebase 的行为，但使用本地 SQLite 数据库（移动端）
/// 或内存存储（Web 端）
/// 可以在不配置 Firebase 的情况下测试应用功能
class MockFirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
  
  static String? _currentUserId;

  /// 初始化 Mock Firebase Service
  static Future<void> initialize() async {
    try {
      if (kIsWeb) {
        // Web 平台使用内存存储
        await WebStorageService.initialize();
        debugPrint('✅ Mock Firebase Service initialized (Web - using in-memory storage)');
      } else {
        // 移动平台使用 SQLite
        await LocalDatabaseService.initialize();
        debugPrint('✅ Mock Firebase Service initialized (Mobile - using SQLite)');
      }
      _currentUserId = await AppConfig.getMockUserId();
      _isInitialized = true;
      debugPrint('📱 Mock User ID: $_currentUserId');
    } catch (e) {
      debugPrint('❌ Mock Firebase Service initialization failed: $e');
      _isInitialized = false;
    }
  }

  /// 获取当前用户 ID
  static String? get currentUserId {
    if (!_isInitialized) return null;
    return _currentUserId;
  }

  /// 模拟匿名登录
  static Future<String?> signInAnonymously() async {
    if (!_isInitialized) {
      await initialize();
    }
    _currentUserId = await AppConfig.getMockUserId();
    debugPrint('✅ Mock anonymous sign in successful');
    return _currentUserId;
  }

  /// 模拟登出
  static Future<void> signOut() async {
    _currentUserId = null;
    debugPrint('✅ Mock sign out successful');
  }

  /// 模拟 Firestore 集合操作
  static Future<void> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    if (!_isInitialized) return;
    
    if (kIsWeb) {
      await WebStorageService.setDocument(
        collection: collection,
        documentId: documentId,
        data: data,
      );
      return;
    }
    
    final db = await LocalDatabaseService.database;
    
    // 根据集合名称选择对应的表
    final tableName = _getTableName(collection);
    if (tableName == null) {
      debugPrint('⚠️ Unknown collection: $collection');
      return;
    }

    // 准备数据，将 DateTime 转换为 ISO 字符串
    final preparedData = _prepareDataForStorage(data);
    preparedData['id'] = documentId;

    await db.insert(
      tableName,
      preparedData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    debugPrint('✅ Mock Firestore: Set document $documentId in $collection');
  }

  /// 模拟 Firestore 查询文档
  static Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    if (!_isInitialized) return null;
    
    if (kIsWeb) {
      return await WebStorageService.getDocument(
        collection: collection,
        documentId: documentId,
      );
    }
    
    final db = await LocalDatabaseService.database;
    final tableName = _getTableName(collection);
    if (tableName == null) return null;

    final results = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [documentId],
      limit: 1,
    );

    if (results.isEmpty) return null;
    
    return _prepareDataFromStorage(results.first);
  }

  /// 模拟 Firestore 查询集合
  static Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    String? whereField,
    dynamic whereValue,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    if (!_isInitialized) return [];
    
    if (kIsWeb) {
      return await WebStorageService.getCollection(
        collection: collection,
        whereField: whereField,
        whereValue: whereValue,
        orderBy: orderBy,
        descending: descending,
        limit: limit,
      );
    }
    
    final db = await LocalDatabaseService.database;
    final tableName = _getTableName(collection);
    if (tableName == null) return [];

    var query = db.query(
      tableName,
      where: whereField != null ? '$whereField = ?' : null,
      whereArgs: whereField != null ? [whereValue] : null,
      orderBy: orderBy != null ? '$orderBy ${descending ? 'DESC' : 'ASC'}' : null,
      limit: limit,
    );

    final results = await query;
    return results.map((row) => _prepareDataFromStorage(row)).toList();
  }

  /// 模拟 Firestore 更新文档
  static Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    if (!_isInitialized) return;
    
    if (kIsWeb) {
      await WebStorageService.updateDocument(
        collection: collection,
        documentId: documentId,
        data: data,
      );
      return;
    }
    
    final db = await LocalDatabaseService.database;
    final tableName = _getTableName(collection);
    if (tableName == null) return;

    final preparedData = _prepareDataForStorage(data);
    
    await db.update(
      tableName,
      preparedData,
      where: 'id = ?',
      whereArgs: [documentId],
    );
    
    debugPrint('✅ Mock Firestore: Updated document $documentId in $collection');
  }

  /// 模拟 Firestore 删除文档
  static Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    if (!_isInitialized) return;
    
    if (kIsWeb) {
      await WebStorageService.deleteDocument(
        collection: collection,
        documentId: documentId,
      );
      return;
    }
    
    final db = await LocalDatabaseService.database;
    final tableName = _getTableName(collection);
    if (tableName == null) return;

    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [documentId],
    );
    
    debugPrint('✅ Mock Firestore: Deleted document $documentId from $collection');
  }

  /// 模拟 Firestore 增量更新
  static Future<void> incrementField({
    required String collection,
    required String documentId,
    required String field,
    required int amount,
  }) async {
    if (!_isInitialized) return;
    
    if (kIsWeb) {
      await WebStorageService.incrementField(
        collection: collection,
        documentId: documentId,
        field: field,
        amount: amount,
      );
      return;
    }
    
    final doc = await getDocument(collection: collection, documentId: documentId);
    if (doc == null) return;

    final currentValue = doc[field] as int? ?? 0;
    await updateDocument(
      collection: collection,
      documentId: documentId,
      data: {field: currentValue + amount},
    );
  }

  /// 将集合名称映射到表名
  static String? _getTableName(String collection) {
    switch (collection) {
      case 'sharing_profiles':
        return 'sharing_profiles';
      case 'community_posts':
        return 'community_posts';
      case 'sharing_links':
        return 'sharing_links';
      case 'privacy_audit':
        return 'privacy_audit';
      default:
        return null;
    }
  }

  /// 准备数据以便存储到 SQLite
  static Map<String, dynamic> _prepareDataForStorage(Map<String, dynamic> data) {
    final prepared = Map<String, dynamic>.from(data);
    
    // 将 List 转换为 JSON 字符串
    prepared.forEach((key, value) {
      if (value is List) {
        prepared[key] = jsonEncode(value);
      } else if (value is DateTime) {
        prepared[key] = value.toIso8601String();
      }
    });
    
    return prepared;
  }

  /// 从 SQLite 读取数据并转换回原始格式
  static Map<String, dynamic> _prepareDataFromStorage(Map<String, dynamic> row) {
    final data = Map<String, dynamic>.from(row);
    
    // 将 JSON 字符串转换回 List
    data.forEach((key, value) {
      if (value is String && value.startsWith('[')) {
        try {
          data[key] = jsonDecode(value);
        } catch (e) {
          // 如果不是 JSON，保持原样
        }
      }
    });
    
    return data;
  }

  /// 清空所有测试数据
  static Future<void> clearAllData() async {
    if (!_isInitialized) return;
    
    if (kIsWeb) {
      await WebStorageService.clearAll();
    } else {
      await LocalDatabaseService.clearAll();
    }
    debugPrint('✅ All mock data cleared');
  }
}

