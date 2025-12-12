import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../domain/entities/sharing_profile.dart';
import '../providers/sharing_providers.dart';

@RoutePage()
class SharingProfilesPage extends ConsumerWidget {
  const SharingProfilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseService.currentUserId ?? MockFirebaseService.currentUserId ?? '';
    final profilesAsync = ref.watch(sharingProfilesProvider(userId));

    // Force refresh when building to ensure local data is up to date
    if (MockFirebaseService.isInitialized) {
      ref.listen(sharingProfilesProvider(userId), (_, __) {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharing Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(sharingProfilesProvider(userId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('List refreshed'), duration: Duration(milliseconds: 500)),
              );
            },
            tooltip: 'Refresh List',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateProfileDialog(context, ref, userId),
            tooltip: 'Create Profile',
          ),
        ],
      ),
      body: profilesAsync.when(
        data: (profiles) {
          if (profiles.isEmpty) {
            return _buildEmptyState(context, ref, userId);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return _buildProfileCard(context, ref, profile);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, String userId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.share, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Sharing Profiles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a profile to control how your data is shared',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateProfileDialog(context, ref, userId),
            icon: const Icon(Icons.add),
            label: const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, SharingProfile profile) {
    final isExpired = profile.expires.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: profile.isActive && !isExpired
              ? AppTheme.primaryColor
              : Colors.grey,
          child: Icon(
            profile.isActive && !isExpired ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          profile.profileName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isExpired ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metrics: ${profile.metrics.join(", ")}'),
            Text('Granularity: ${profile.granularity}'),
            Text(
              'Expires: ${DateFormat('yyyy-MM-dd').format(profile.expires)}',
              style: TextStyle(
                color: isExpired ? Colors.red : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: () => _showEditProfileDialog(context, ref, profile),
            ),
            PopupMenuItem(
              child: Text(profile.isActive ? 'Deactivate' : 'Activate'),
              onTap: () => _toggleProfile(context, ref, profile),
            ),
            PopupMenuItem(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                // Delay to allow popup menu to close before showing dialog
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    _deleteProfile(context, ref, profile);
                  }
                });
              },
            ),
          ],
        ),
        onTap: () => _showProfileDetails(context, profile),
      ),
    );
  }

  void _showCreateProfileDialog(BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (context) => _CreateProfileDialog(userId: userId),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, SharingProfile profile) {
    showDialog(
      context: context,
      builder: (context) => _CreateProfileDialog(userId: profile.userId, profile: profile),
    );
  }

  void _toggleProfile(BuildContext context, WidgetRef ref, SharingProfile profile) async {
    final repository = ref.read(sharingProfileRepositoryProvider);
    final updated = profile.copyWith(isActive: !profile.isActive);
    await repository.updateSharingProfile(updated);
    
    // In local mode, force refresh
    ref.invalidate(sharingProfilesProvider(profile.userId));
  }

  void _deleteProfile(BuildContext context, WidgetRef ref, SharingProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text('Are you sure you want to delete "${profile.profileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final repository = ref.read(sharingProfileRepositoryProvider);
                print('🗑️ Requesting delete for profile: ${profile.id}');
                await repository.deleteSharingProfile(profile.id);
                
                // Add a small delay to ensure storage operation completes
                await Future.delayed(const Duration(milliseconds: 200));
                
                // In local mode, force refresh
                print('🔄 Invalidating provider to refresh list');
                ref.invalidate(sharingProfilesProvider(profile.userId));
                
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile deleted')),
                  );
                }
              } catch (e) {
                print('❌ Error deleting profile: $e');
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting profile: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showProfileDetails(BuildContext context, SharingProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(profile.profileName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metrics: ${profile.metrics.join(", ")}'),
            const SizedBox(height: 8),
            Text('Granularity: ${profile.granularity}'),
            const SizedBox(height: 8),
            Text('Expires: ${DateFormat('yyyy-MM-dd').format(profile.expires)}'),
            const SizedBox(height: 8),
            Text('Status: ${profile.isActive ? "Active" : "Inactive"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _CreateProfileDialog extends ConsumerStatefulWidget {
  final String userId;
  final SharingProfile? profile;

  const _CreateProfileDialog({required this.userId, this.profile});

  @override
  ConsumerState<_CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends ConsumerState<_CreateProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<String> _selectedMetrics = [];
  String _selectedGranularity = 'daily_avg';
  DateTime _expiresDate = DateTime.now().add(const Duration(days: 365));

  final List<String> _availableMetrics = ['glucose', 'BHB', 'GKI', 'weight', 'heart_rate'];
  final Map<String, String> _granularityOptions = {
    'raw': 'Raw Data',
    'hourly': 'Hourly Average',
    'daily_avg': 'Daily Average',
    'weekly_avg': 'Weekly Average',
    'monthly_avg': 'Monthly Average',
  };

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      _nameController.text = widget.profile!.profileName;
      _selectedMetrics.addAll(widget.profile!.metrics);
      _selectedGranularity = widget.profile!.granularity;
      _expiresDate = widget.profile!.expires;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.profile == null ? 'Create Profile' : 'Edit Profile'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Profile Name',
                  hintText: 'e.g., Doctor, Research',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a profile name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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
              DropdownButtonFormField<String>(
                value: _selectedGranularity,
                decoration: const InputDecoration(labelText: 'Granularity'),
                items: _granularityOptions.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedGranularity = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Expiration Date'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(_expiresDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _expiresDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null) {
                    setState(() => _expiresDate = date);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveProfile,
          child: Text(widget.profile == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMetrics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one metric')),
      );
      return;
    }

    final repository = ref.read(sharingProfileRepositoryProvider);
    final _uuid = const Uuid();

    final profile = SharingProfile(
      id: widget.profile?.id ?? _uuid.v4(),
      userId: widget.userId,
      profileName: _nameController.text,
      metrics: _selectedMetrics,
      granularity: _selectedGranularity,
      expires: _expiresDate,
      createdAt: widget.profile?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: widget.profile?.isActive ?? true,
    );

    repository.saveSharingProfile(profile);
    
    // In local mode, we need to manually invalidate the provider to trigger a refresh
    // because our mock repository uses Stream.fromFuture which doesn't auto-update
    ref.invalidate(sharingProfilesProvider(widget.userId));
    
    Navigator.of(context).pop();
  }
}



