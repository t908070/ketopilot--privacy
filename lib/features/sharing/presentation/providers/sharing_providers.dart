import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/sharing_profile_repository.dart';
import '../../data/repositories/sharing_link_repository.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/sharing_profile.dart';
import '../../domain/entities/sharing_link.dart';

final sharingProfileRepositoryProvider = Provider<SharingProfileRepository>((ref) {
  return SharingProfileRepository();
});

final sharingLinkRepositoryProvider = Provider<SharingLinkRepository>((ref) {
  return SharingLinkRepository();
});

final sharingProfilesProvider = StreamProvider.family<List<SharingProfile>, String>((ref, userId) {
  final repository = ref.watch(sharingProfileRepositoryProvider);
  return repository.watchSharingProfiles(userId);
});

final sharingLinksProvider = StreamProvider.family<List<SharingLink>, String>((ref, userId) {
  final repository = ref.watch(sharingLinkRepositoryProvider);
  return repository.watchSharingLinks(userId);
});




