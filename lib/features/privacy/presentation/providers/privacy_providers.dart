import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/privacy_audit_repository.dart';
import '../../domain/entities/privacy_audit_log.dart';
import '../../../../core/firebase/firebase_service.dart';

final privacyAuditRepositoryProvider = Provider<PrivacyAuditRepository>((ref) {
  return PrivacyAuditRepository();
});

final privacyAuditLogsProvider = StreamProvider.family<List<PrivacyAuditLog>, String>((ref, userId) {
  final repository = ref.watch(privacyAuditRepositoryProvider);
  return repository.watchAuditLogs(userId, limit: 100);
});

final privacyAccessSummaryProvider = FutureProvider.family<Map<String, int>, String>((ref, userId) async {
  final repository = ref.watch(privacyAuditRepositoryProvider);
  return await repository.getAccessSummary(userId);
});




