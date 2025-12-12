import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Web 平台存储服务 - 使用 IndexedDB/SharedPreferences 作为替代
/// 
/// 由于 Web 平台不支持 SQLite，我们使用 SharedPreferences 作为替代方案
class WebStorageService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
  
  static final Map<String, List<Map<String, dynamic>>> _collections = {};
  
  /// 初始化 Web 存储服务
  static Future<void> initialize() async {
    try {
      _isInitialized = true;
      debugPrint('✅ Web Storage Service initialized (using in-memory storage)');
      debugPrint('⚠️ Note: Data will be lost on page refresh. For persistent storage, use SharedPreferences.');
    } catch (e) {
      debugPrint('❌ Web Storage Service initialization failed: $e');
      _isInitialized = false;
    }
  }
  
  /// 设置文档
  static Future<void> setDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    if (!_isInitialized) return;
    
    if (!_collections.containsKey(collection)) {
      _collections[collection] = [];
    }
    
    // 查找现有文档
    final index = _collections[collection]!.indexWhere((doc) => doc['id'] == documentId);
    
    final document = Map<String, dynamic>.from(data);
    document['id'] = documentId;
    
    if (index >= 0) {
      _collections[collection]![index] = document;
    } else {
      _collections[collection]!.add(document);
    }
    
    debugPrint('✅ Web Storage: Set document $documentId in $collection');
  }
  
  /// 获取文档
  static Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    if (!_isInitialized) return null;
    
    if (!_collections.containsKey(collection)) return null;
    
    try {
      final doc = _collections[collection]!.firstWhere(
        (doc) => doc['id'] == documentId,
      );
      return Map<String, dynamic>.from(doc);
    } catch (e) {
      return null;
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
    if (!_isInitialized) return [];
    
    if (!_collections.containsKey(collection)) return [];
    
    var results = List<Map<String, dynamic>>.from(_collections[collection]!);
    
    // 应用过滤
    if (whereField != null && whereValue != null) {
      results = results.where((doc) => doc[whereField] == whereValue).toList();
    }
    
    // 应用排序
    if (orderBy != null) {
      results.sort((a, b) {
        final aValue = a[orderBy];
        final bValue = b[orderBy];
        
        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return 1;
        if (bValue == null) return -1;
        
        final comparison = aValue.compareTo(bValue);
        return descending ? -comparison : comparison;
      });
    }
    
    // 应用限制
    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }
    
    return results.map((doc) => Map<String, dynamic>.from(doc)).toList();
  }
  
  /// 更新文档
  static Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    if (!_isInitialized) return;
    
    if (!_collections.containsKey(collection)) return;
    
    final index = _collections[collection]!.indexWhere((doc) => doc['id'] == documentId);
    if (index >= 0) {
      _collections[collection]![index].addAll(data);
      debugPrint('✅ Web Storage: Updated document $documentId in $collection');
    }
  }
  
  /// 删除文档
  static Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    if (!_isInitialized) return;
    
    if (!_collections.containsKey(collection)) {
      debugPrint('⚠️ Web Storage: Collection $collection does not exist');
      return;
    }
    
    final initialLength = _collections[collection]!.length;
    _collections[collection]!.removeWhere((doc) => doc['id'] == documentId);
    final finalLength = _collections[collection]!.length;
    
    if (initialLength > finalLength) {
      debugPrint('✅ Web Storage: Deleted document $documentId from $collection (Count: $initialLength -> $finalLength)');
    } else {
      debugPrint('⚠️ Web Storage: Document $documentId not found in $collection to delete');
      // 打印所有现有 ID 以供调试
      debugPrint('   Existing IDs: ${_collections[collection]!.map((d) => d['id']).join(', ')}');
    }
  }
  
  /// 增量更新字段
  static Future<void> incrementField({
    required String collection,
    required String documentId,
    required String field,
    required int amount,
  }) async {
    if (!_isInitialized) return;
    
    final doc = await getDocument(collection: collection, documentId: documentId);
    if (doc == null) return;
    
    final currentValue = doc[field] as int? ?? 0;
    await updateDocument(
      collection: collection,
      documentId: documentId,
      data: {field: currentValue + amount},
    );
  }
  
  /// 清空所有数据
  static Future<void> clearAll() async {
    _collections.clear();
    debugPrint('✅ All web storage data cleared');
  }
  
  /// 获取统计信息
  static Map<String, int> getStats() {
    return {
      for (var entry in _collections.entries)
        entry.key: entry.value.length,
    };
  }
}


