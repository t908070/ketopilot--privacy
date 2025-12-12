import 'package:freezed_annotation/freezed_annotation.dart';

part 'sharing_profile.freezed.dart';
part 'sharing_profile.g.dart';

@freezed
class SharingProfile with _$SharingProfile {
  const factory SharingProfile({
    required String id,
    required String userId,
    required String profileName,
    required List<String> metrics,
    required String granularity,
    required DateTime expires,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(false) bool isActive,
  }) = _SharingProfile;

  factory SharingProfile.fromJson(Map<String, dynamic> json) =>
      _$SharingProfileFromJson(json);
}

enum SharingGranularity {
  raw,
  hourly,
  dailyAvg,
  weeklyAvg,
  monthlyAvg,
}

extension SharingGranularityExtension on SharingGranularity {
  String get displayName {
    switch (this) {
      case SharingGranularity.raw:
        return 'Raw Data';
      case SharingGranularity.hourly:
        return 'Hourly Average';
      case SharingGranularity.dailyAvg:
        return 'Daily Average';
      case SharingGranularity.weeklyAvg:
        return 'Weekly Average';
      case SharingGranularity.monthlyAvg:
        return 'Monthly Average';
    }
  }

  String get value {
    switch (this) {
      case SharingGranularity.raw:
        return 'raw';
      case SharingGranularity.hourly:
        return 'hourly';
      case SharingGranularity.dailyAvg:
        return 'daily_avg';
      case SharingGranularity.weeklyAvg:
        return 'weekly_avg';
      case SharingGranularity.monthlyAvg:
        return 'monthly_avg';
    }
  }

  static SharingGranularity fromString(String value) {
    switch (value) {
      case 'raw':
        return SharingGranularity.raw;
      case 'hourly':
        return SharingGranularity.hourly;
      case 'daily_avg':
        return SharingGranularity.dailyAvg;
      case 'weekly_avg':
        return SharingGranularity.weeklyAvg;
      case 'monthly_avg':
        return SharingGranularity.monthlyAvg;
      default:
        return SharingGranularity.dailyAvg;
    }
  }
}

enum SharingProfileType {
  private,
  doctor,
  research,
  community,
}

extension SharingProfileTypeExtension on SharingProfileType {
  String get displayName {
    switch (this) {
      case SharingProfileType.private:
        return 'Private';
      case SharingProfileType.doctor:
        return 'Doctor';
      case SharingProfileType.research:
        return 'Research';
      case SharingProfileType.community:
        return 'Community';
    }
  }
}




