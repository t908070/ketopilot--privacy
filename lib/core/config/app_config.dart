import 'package:shared_preferences/shared_preferences.dart';

/// 应用配置类 - 控制是否使用本地测试模式
class AppConfig {
  static const String _useLocalModeKey = 'use_local_mode';
  static const String _mockUserIdKey = 'mock_user_id';

  /// 是否使用本地模式（不使用 Firebase）
  static Future<bool> get useLocalMode async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useLocalModeKey) ?? false;
  }

  /// 设置是否使用本地模式
  static Future<void> setUseLocalMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useLocalModeKey, value);
  }

  /// 获取或创建 Mock 用户 ID（用于本地测试）
  static Future<String> getMockUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_mockUserIdKey);
    
    if (userId == null) {
      // 生成一个固定的测试用户 ID
      userId = 'local_test_user_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_mockUserIdKey, userId);
    }
    
    return userId;
  }

  /// 清除 Mock 用户 ID（用于重置测试数据）
  static Future<void> clearMockUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mockUserIdKey);
  }
}



