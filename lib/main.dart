import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/firebase/firebase_service.dart';
import 'core/firebase/mock_firebase_service.dart';
import 'core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🔧 强制启用本地测试模式（无需 Firebase 配置）
  await AppConfig.setUseLocalMode(true);
  
  // 检查是否使用本地测试模式
  final useLocalMode = await AppConfig.useLocalMode;
  
  if (useLocalMode) {
    // 使用本地 Mock Firebase Service（不需要真实 Firebase 配置）
    print('🔧 使用本地测试模式 - 无需 Firebase 配置');
    await MockFirebaseService.initialize();
  } else {
    // 尝试初始化真实的 Firebase
    await FirebaseService.initialize();
  }
  
  runApp(const ProviderScope(child: MetabolicHealthApp()));
}

class MetabolicHealthApp extends StatelessWidget {
  const MetabolicHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Metabolic Health Companion',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
