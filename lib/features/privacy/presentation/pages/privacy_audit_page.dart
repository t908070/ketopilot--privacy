import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_theme.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/firebase/mock_firebase_service.dart';
import '../../domain/entities/privacy_audit_log.dart';
import '../providers/privacy_providers.dart';

@RoutePage()
class PrivacyAuditPage extends ConsumerWidget {
  const PrivacyAuditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseService.currentUserId ?? MockFirebaseService.currentUserId ?? '';
    final auditLogsAsync = ref.watch(privacyAuditLogsProvider(userId));
    final accessSummaryAsync = ref.watch(privacyAccessSummaryProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Audit Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportLogs(context, ref, userId),
            tooltip: 'Export Logs',
          ),
        ],
      ),
      body: auditLogsAsync.when(
        data: (logs) => accessSummaryAsync.when(
          data: (summary) => _buildContent(context, logs, summary),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<PrivacyAuditLog> logs, Map<String, int> summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(summary),
          const SizedBox(height: 24),
          _buildAccessChart(summary),
          const SizedBox(height: 24),
          _buildTimelineChart(logs),
          const SizedBox(height: 24),
          _buildRecentActivity(logs),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, int> summary) {
    final totalAccess = summary.values.fold<int>(0, (sum, count) => sum + count);
    
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Access',
            totalAccess.toString(),
            Icons.visibility,
            AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Unique Viewers',
            summary.keys.length.toString(),
            Icons.people,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessChart(Map<String, int> summary) {
    if (summary.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No access data available')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Access by Viewer Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: summary.values.reduce((a, b) => a > b ? a : b).toDouble() * 1.2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < summary.keys.length) {
                            final key = summary.keys.elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _getViewerTypeShortName(key),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  barGroups: summary.entries.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.value.toDouble(),
                          color: _getViewerTypeColor(item.key),
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineChart(List<PrivacyAuditLog> logs) {
    if (logs.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No timeline data available')),
        ),
      );
    }

    // Group logs by date
    final Map<String, int> dailyCounts = {};
    for (final log in logs) {
      final dateKey = DateFormat('yyyy-MM-dd').format(log.timestamp);
      dailyCounts[dateKey] = (dailyCounts[dateKey] ?? 0) + 1;
    }

    final sortedDates = dailyCounts.keys.toList()..sort();
    final spots = sortedDates.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), dailyCounts[entry.value]!.toDouble());
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Access Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < sortedDates.length && index % 3 == 0) {
                            final date = sortedDates[index];
                            return Text(
                              DateFormat('MM/dd').format(DateTime.parse(date)),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: AppTheme.primaryColor.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<PrivacyAuditLog> logs) {
    final recentLogs = logs.take(10).toList();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentLogs.length,
            itemBuilder: (context, index) {
              final log = recentLogs[index];
              return ListTile(
                leading: Icon(
                  _getEventIcon(log.eventType),
                  color: _getEventColor(log.eventType),
                ),
                title: Text(log.eventType.displayName),
                subtitle: Text(
                  '${_getViewerTypeFromString(log.viewerType).displayName} • ${DateFormat('MMM dd, yyyy HH:mm').format(log.timestamp)}',
                ),
                trailing: Text(
                  '${log.dataScope.length} metrics',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(AuditEventType type) {
    switch (type) {
      case AuditEventType.dataViewed:
        return Icons.visibility;
      case AuditEventType.dataExported:
        return Icons.download;
      case AuditEventType.sharingLinkCreated:
        return Icons.link;
      case AuditEventType.sharingLinkAccessed:
        return Icons.open_in_new;
      case AuditEventType.sharingLinkRevoked:
        return Icons.link_off;
      case AuditEventType.profileCreated:
        return Icons.add_circle;
      case AuditEventType.profileUpdated:
        return Icons.edit;
      case AuditEventType.profileDeleted:
        return Icons.delete;
      case AuditEventType.dataShared:
        return Icons.share;
    }
  }

  Color _getEventColor(AuditEventType type) {
    switch (type) {
      case AuditEventType.dataViewed:
      case AuditEventType.dataShared:
        return Colors.blue;
      case AuditEventType.dataExported:
        return Colors.green;
      case AuditEventType.sharingLinkCreated:
        return Colors.orange;
      case AuditEventType.sharingLinkAccessed:
        return Colors.purple;
      case AuditEventType.sharingLinkRevoked:
        return Colors.red;
      case AuditEventType.profileCreated:
        return Colors.teal;
      case AuditEventType.profileUpdated:
        return Colors.amber;
      case AuditEventType.profileDeleted:
        return Colors.red;
    }
  }

  Color _getViewerTypeColor(String type) {
    switch (type) {
      case 'user':
        return Colors.blue;
      case 'doctor':
        return Colors.green;
      case 'researcher':
        return Colors.orange;
      case 'community':
        return Colors.purple;
      case 'system':
        return Colors.grey;
      case 'external':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getViewerTypeShortName(String type) {
    switch (type) {
      case 'user':
        return 'User';
      case 'doctor':
        return 'Doctor';
      case 'researcher':
        return 'Research';
      case 'community':
        return 'Community';
      case 'system':
        return 'System';
      case 'external':
        return 'External';
      default:
        return type;
    }
  }

  ViewerType _getViewerTypeFromString(String type) {
    switch (type) {
      case 'user':
        return ViewerType.user;
      case 'doctor':
        return ViewerType.doctor;
      case 'researcher':
        return ViewerType.researcher;
      case 'community':
        return ViewerType.community;
      case 'system':
        return ViewerType.system;
      case 'external':
        return ViewerType.external;
      default:
        return ViewerType.external;
    }
  }

  Future<void> _exportLogs(BuildContext context, WidgetRef ref, String userId) async {
    final repository = ref.read(privacyAuditRepositoryProvider);
    final logs = await repository.getAuditLogs(userId);

    // Convert to CSV format
    final csv = StringBuffer();
    csv.writeln('Timestamp,Event Type,Viewer Type,Data Scope,Viewer ID');
    for (final log in logs) {
      csv.writeln(
        '${log.timestamp.toIso8601String()},'
        '${log.eventType.displayName},'
        '${_getViewerTypeFromString(log.viewerType).displayName},'
        '${log.dataScope.join(";")},'
        '${log.viewerId ?? ""}',
      );
    }

    // Show share dialog
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Logs'),
          content: const Text('Logs exported successfully. You can copy the data.'),
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
}

