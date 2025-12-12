import 'package:freezed_annotation/freezed_annotation.dart';

part 'sharing_link.freezed.dart';
part 'sharing_link.g.dart';

@freezed
class SharingLink with _$SharingLink {
  const factory SharingLink({
    required String id,
    required String userId,
    required String token,
    required String linkUrl,
    required DateTime expiresAt,
    required DateTime createdAt,
    DateTime? revokedAt,
    @Default(false) bool isRevoked,
    required List<String> sharedMetrics,
    required String summaryType,
    Map<String, dynamic>? metadata,
  }) = _SharingLink;

  factory SharingLink.fromJson(Map<String, dynamic> json) =>
      _$SharingLinkFromJson(json);
}

enum SummaryType {
  oneWeek,
  twoWeeks,
  oneMonth,
  threeMonths,
  custom,
}

extension SummaryTypeExtension on SummaryType {
  String get displayName {
    switch (this) {
      case SummaryType.oneWeek:
        return '1 Week';
      case SummaryType.twoWeeks:
        return '2 Weeks';
      case SummaryType.oneMonth:
        return '1 Month';
      case SummaryType.threeMonths:
        return '3 Months';
      case SummaryType.custom:
        return 'Custom';
    }
  }

  int get days {
    switch (this) {
      case SummaryType.oneWeek:
        return 7;
      case SummaryType.twoWeeks:
        return 14;
      case SummaryType.oneMonth:
        return 30;
      case SummaryType.threeMonths:
        return 90;
      case SummaryType.custom:
        return 7; // Default
    }
  }

  String get value {
    switch (this) {
      case SummaryType.oneWeek:
        return 'one_week';
      case SummaryType.twoWeeks:
        return 'two_weeks';
      case SummaryType.oneMonth:
        return 'one_month';
      case SummaryType.threeMonths:
        return 'three_months';
      case SummaryType.custom:
        return 'custom';
    }
  }
}

