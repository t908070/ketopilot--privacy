import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/data_entry/presentation/pages/data_entry_page.dart';
import '../../features/food_diary/presentation/pages/food_diary_page.dart';
import '../../features/health_logging/presentation/pages/health_logging_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/sharing/presentation/pages/sharing_profiles_page.dart';
import '../../features/sharing/presentation/pages/sharing_links_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/privacy/presentation/pages/privacy_audit_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Onboarding route
    AutoRoute(page: OnboardingRoute.page, path: '/onboarding', initial: true),

    // Main app routes
    AutoRoute(page: DashboardRoute.page, path: '/dashboard'),

    AutoRoute(page: DataEntryRoute.page, path: '/data-entry'),

    AutoRoute(page: FoodDiaryRoute.page, path: '/food-diary'),

    AutoRoute(page: HealthLoggingRoute.page, path: '/health-logging'),

    AutoRoute(page: SettingsRoute.page, path: '/settings'),

    // KetoLink routes
    AutoRoute(page: SharingProfilesRoute.page, path: '/sharing-profiles'),
    AutoRoute(page: SharingLinksRoute.page, path: '/sharing-links'),
    AutoRoute(page: CommunityRoute.page, path: '/community'),
    AutoRoute(page: PrivacyAuditRoute.page, path: '/privacy-audit'),
  ];
}
