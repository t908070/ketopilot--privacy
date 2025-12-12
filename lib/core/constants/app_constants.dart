class AppConstants {
  // App Info
  static const String appName = 'Metabolic Health Companion';
  static const String appVersion = '1.0.0';

  // Therapeutic Ranges
  static const double optimalGkiLower = 1.0;
  static const double optimalGkiUpper = 3.0;
  static const double therapeuticKetones = 0.5;
  static const double normalGlucoseUpper = 100.0;

  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'theme_mode';

  // Database
  static const String databaseName = 'metabolic_health.db';
  static const int databaseVersion = 1;

  // Validation
  static const double minWeight = 30.0;
  static const double maxWeight = 500.0;
  static const double minGlucose = 20.0;
  static const double maxGlucose = 400.0;
  static const double minKetones = 0.0;
  static const double maxKetones = 8.0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 40.0;

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Default Macro Goals
  static const double defaultCarbsLimit = 20.0;
  static const double defaultProteinGoal = 100.0;
  static const double defaultFatGoal = 150.0;

  // Optimal Ranges
  static const double optimalGlucoseUpper = 100.0;
  static const double optimalKetonesLower = 0.5;

  // KetoLink Constants
  static const String firestoreSharingProfilesCollection = 'sharing_profiles';
  static const String firestoreCommunityPostsCollection = 'community_posts';
  static const String firestoreSharingLinksCollection = 'sharing_links';
  static const String firestorePrivacyAuditCollection = 'privacy_audit';
  static const int defaultSharingLinkExpirationDays = 7;
  static const int maxSharingLinkExpirationDays = 90;
}
