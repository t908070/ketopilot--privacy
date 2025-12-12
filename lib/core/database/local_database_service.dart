import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

/// 本地数据库服务 - Firebase 的替代方案
/// 
/// 使用 SQLite 存储数据，完全离线工作
/// 注意：此服务不提供跨设备同步功能
class LocalDatabaseService {
  static Database? _database;
  static const String _databaseName = 'ketopilot.db';
  static const int _databaseVersion = 1;

  /// 获取数据库实例
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 创建数据库表
  static Future<void> _onCreate(Database db, int version) async {
    // Sharing Profiles 表
    await db.execute('''
      CREATE TABLE sharing_profiles (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        profile_name TEXT NOT NULL,
        metrics TEXT NOT NULL,
        granularity TEXT NOT NULL,
        expires TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // Community Posts 表
    await db.execute('''
      CREATE TABLE community_posts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        alias TEXT NOT NULL,
        content TEXT NOT NULL,
        post_type TEXT NOT NULL,
        image_urls TEXT,
        sentiment_score REAL DEFAULT 0.0,
        likes INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');

    // Sharing Links 表
    await db.execute('''
      CREATE TABLE sharing_links (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        token TEXT NOT NULL UNIQUE,
        link_url TEXT NOT NULL,
        shared_metrics TEXT NOT NULL,
        summary_type TEXT NOT NULL,
        expires_at TEXT NOT NULL,
        is_revoked INTEGER DEFAULT 0,
        revoked_at TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Privacy Audit 表
    await db.execute('''
      CREATE TABLE privacy_audit (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        action TEXT NOT NULL,
        resource_type TEXT NOT NULL,
        resource_id TEXT,
        timestamp TEXT NOT NULL,
        metadata TEXT
      )
    ''');

    // 创建索引以提高查询性能
    await db.execute('CREATE INDEX idx_sharing_profiles_user_id ON sharing_profiles(user_id)');
    await db.execute('CREATE INDEX idx_sharing_profiles_created_at ON sharing_profiles(created_at)');
    await db.execute('CREATE INDEX idx_community_posts_user_id ON community_posts(user_id)');
    await db.execute('CREATE INDEX idx_community_posts_created_at ON community_posts(created_at)');
    await db.execute('CREATE INDEX idx_sharing_links_user_id ON sharing_links(user_id)');
    await db.execute('CREATE INDEX idx_sharing_links_token ON sharing_links(token)');
    await db.execute('CREATE INDEX idx_privacy_audit_user_id ON privacy_audit(user_id)');
    await db.execute('CREATE INDEX idx_privacy_audit_timestamp ON privacy_audit(timestamp)');
  }

  /// 数据库升级
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 在这里处理数据库版本升级
    if (oldVersion < 2) {
      // 示例：添加新列
      // await db.execute('ALTER TABLE sharing_profiles ADD COLUMN new_field TEXT');
    }
  }

  /// 检查数据库是否已初始化
  static bool get isInitialized => _database != null;

  /// 初始化服务
  static Future<void> initialize() async {
    try {
      await database;
      debugPrint('✅ Local database initialized successfully');
    } catch (e) {
      debugPrint('❌ Local database initialization failed: $e');
      rethrow;
    }
  }

  /// 关闭数据库
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// 清空所有数据（用于测试或重置）
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('sharing_profiles');
    await db.delete('community_posts');
    await db.delete('sharing_links');
    await db.delete('privacy_audit');
  }

  /// 获取数据库统计信息
  static Future<Map<String, int>> getStats() async {
    final db = await database;
    
    final profilesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM sharing_profiles')
    ) ?? 0;
    
    final postsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM community_posts')
    ) ?? 0;
    
    final linksCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM sharing_links')
    ) ?? 0;
    
    final auditCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM privacy_audit')
    ) ?? 0;

    return {
      'profiles': profilesCount,
      'posts': postsCount,
      'links': linksCount,
      'audit_logs': auditCount,
    };
  }
}

