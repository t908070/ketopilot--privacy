import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/health_metric_repository.dart';
import '../../data/repositories/gki_repository.dart';
import '../../domain/entities/health_metric.dart';

final healthMetricRepositoryProvider = Provider<HealthMetricRepository>((ref) {
  return HealthMetricRepository();
});

final gkiRepositoryProvider = Provider<GkiRepository>((ref) {
  return GkiRepository();
});

final latestHealthMetricsProvider = FutureProvider<Map<HealthMetricType, HealthMetric?>>((ref) async {
  final repository = ref.watch(healthMetricRepositoryProvider);
  return await repository.getLatestMetrics();
});

final latestGkiProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final repository = ref.watch(gkiRepositoryProvider);
  return await repository.getLatestGKI();
});

final recentHealthMetricsProvider = FutureProvider.family<List<HealthMetric>, int>((ref, limit) async {
  final repository = ref.watch(healthMetricRepositoryProvider);
  return await repository.getHealthMetrics(limit: limit);
});

final healthMetricsByTypeProvider = FutureProvider.family<List<HealthMetric>, HealthMetricType>((ref, type) async {
  final repository = ref.watch(healthMetricRepositoryProvider);
  return await repository.getHealthMetrics(type: type);
});




