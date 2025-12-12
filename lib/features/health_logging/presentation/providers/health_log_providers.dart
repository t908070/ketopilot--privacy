import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/health_log_repository.dart';

final healthLogRepositoryProvider = Provider<HealthLogRepository>((ref) {
  return HealthLogRepository();
});

final recentHealthLogsProvider = FutureProvider.family<List<HealthLog>, int>((ref, limit) async {
  final repository = ref.watch(healthLogRepositoryProvider);
  return await repository.getHealthLogs(limit: limit);
});




