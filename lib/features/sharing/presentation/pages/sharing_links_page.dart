import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/services.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/sharing_link.dart';
import '../providers/sharing_providers.dart';

@RoutePage()
class SharingLinksPage extends ConsumerWidget {
  const SharingLinksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseService.currentUserId ?? MockFirebaseService.currentUserId ?? '';
    final linksAsync = ref.watch(sharingLinksProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharing Links'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateLinkDialog(context, ref, userId),
            tooltip: 'Create Link',
          ),
        ],
      ),
      body: linksAsync.when(
        data: (links) {
          if (links.isEmpty) {
            return _buildEmptyState(context, ref, userId);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: links.length,
            itemBuilder: (context, index) {
              final link = links[index];
              return _buildLinkCard(context, ref, link);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, String userId) {
    final isFirebaseInitialized = FirebaseService.isInitialized;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.link, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Sharing Links',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a time-limited link to share your data',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          if (!isFirebaseInitialized) ...[
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Firebase not configured. Links will not be saved.',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateLinkDialog(context, ref, userId),
            icon: const Icon(Icons.add),
            label: const Text('Create Link'),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, WidgetRef ref, SharingLink link) {
    final isExpired = link.expiresAt.isBefore(DateTime.now());
    final isValid = !link.isRevoked && !isExpired;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isValid ? Icons.link : Icons.link_off,
                  color: isValid ? AppTheme.primaryColor : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shared: ${link.sharedMetrics.join(", ")}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Summary: ${link.summaryType}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (isValid)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      link.isRevoked ? 'Revoked' : 'Expired',
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Expires: ${DateFormat('yyyy-MM-dd HH:mm').format(link.expiresAt)}',
              style: TextStyle(
                fontSize: 12,
                color: isExpired ? Colors.red : Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isValid
                        ? () => _copyLink(context, link.linkUrl)
                        : null,
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy Link'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isValid
                        ? () => _shareLink(context, link.linkUrl)
                        : null,
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Share'),
                  ),
                ),
                if (isValid) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _revokeLink(context, ref, link),
                    tooltip: 'Revoke',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateLinkDialog(BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (context) => _CreateLinkDialog(userId: userId),
    );
  }

  void _copyLink(BuildContext context, String linkUrl) {
    Clipboard.setData(ClipboardData(text: linkUrl)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link copied: $linkUrl')),
        );
      }
    });
  }

  void _shareLink(BuildContext context, String linkUrl) {
    Share.share(linkUrl, subject: 'KetoLink Data Sharing');
  }

  void _revokeLink(BuildContext context, WidgetRef ref, SharingLink link) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Link'),
        content: const Text('Are you sure you want to revoke this sharing link?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final repository = ref.read(sharingLinkRepositoryProvider);
              repository.revokeSharingLink(link.id);
              
              // Force refresh for local mode
              ref.invalidate(sharingLinksProvider(link.userId));
              
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link revoked successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }
}

class _CreateLinkDialog extends ConsumerStatefulWidget {
  final String userId;

  const _CreateLinkDialog({required this.userId});

  @override
  ConsumerState<_CreateLinkDialog> createState() => _CreateLinkDialogState();
}

class _CreateLinkDialogState extends ConsumerState<_CreateLinkDialog> {
  final List<String> _selectedMetrics = ['glucose', 'BHB'];
  SummaryType _selectedSummaryType = SummaryType.oneWeek;
  int _expirationDays = AppConstants.defaultSharingLinkExpirationDays;

  final List<String> _availableMetrics = ['glucose', 'BHB', 'GKI', 'weight', 'heart_rate'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Sharing Link'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Metrics:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._availableMetrics.map((metric) => CheckboxListTile(
              title: Text(metric),
              value: _selectedMetrics.contains(metric),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedMetrics.add(metric);
                  } else {
                    _selectedMetrics.remove(metric);
                  }
                });
              },
            )),
            const SizedBox(height: 16),
            DropdownButtonFormField<SummaryType>(
              value: _selectedSummaryType,
              decoration: const InputDecoration(labelText: 'Summary Period'),
              items: SummaryType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedSummaryType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Text('Expiration: $_expirationDays days'),
            Slider(
              value: _expirationDays.toDouble(),
              min: 1,
              max: AppConstants.maxSharingLinkExpirationDays.toDouble(),
              divisions: AppConstants.maxSharingLinkExpirationDays - 1,
              label: '$_expirationDays days',
              onChanged: (value) {
                setState(() => _expirationDays = value.toInt());
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createLink,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createLink() {
    if (_selectedMetrics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one metric')),
      );
      return;
    }

    // Check if Firebase is initialized (or Mock service for local testing)
    if (!FirebaseService.isInitialized && !MockFirebaseService.isInitialized) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Firebase is not configured. Link created but not saved. Please configure Firebase to persist data.'),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final repository = ref.read(sharingLinkRepositoryProvider);
    
    repository.createSharingLink(
      userId: widget.userId,
      sharedMetrics: _selectedMetrics,
      summaryType: _selectedSummaryType,
      expirationDays: _expirationDays,
    ).then((link) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link created: ${link.linkUrl}'),
          action: SnackBarAction(
            label: 'Copy',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: link.linkUrl));
            },
          ),
        ),
      );
      
      // Force refresh for local mode
      ref.invalidate(sharingLinksProvider(widget.userId));
      
    }).catchError((error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating link: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}

