import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_service.dart';
import '../../domain/entities/health_metric.dart';

class HealthMetricRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<void> saveHealthMetric(HealthMetric metric) async {
    final db = await _dbService.database;
    await db.insert(
      'health_metrics',
      {
        'id': metric.id,
        'timestamp': metric.timestamp.millisecondsSinceEpoch,
        'type': metric.type.name,
        'value': metric.value,
        'unit': metric.unit,
        'notes': metric.notes,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HealthMetric>> getHealthMetrics({
    HealthMetricType? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final db = await _dbService.database;
    
    String query = 'SELECT * FROM health_metrics WHERE 1=1';
    List<dynamic> args = [];

    if (type != null) {
      query += ' AND type = ?';
      args.add(type.name);
    }

    if (startDate != null) {
      query += ' AND timestamp >= ?';
      args.add(startDate.millisecondsSinceEpoch);
    }

    if (endDate != null) {
      query += ' AND timestamp <= ?';
      args.add(endDate.millisecondsSinceEpoch);
    }

    query += ' ORDER BY timestamp DESC';

    if (limit != null) {
      query += ' LIMIT ?';
      args.add(limit);
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, args);

    return maps.map((map) => HealthMetric(
      id: map['id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      type: HealthMetricType.values.firstWhere(
        (e) => e.name == map['type'] as String,
      ),
      value: map['value'] as double,
      unit: map['unit'] as String,
      notes: map['notes'] as String?,
    )).toList();
  }

  Future<HealthMetric?> getLatestHealthMetric(HealthMetricType type) async {
    final metrics = await getHealthMetrics(type: type, limit: 1);
    return metrics.isNotEmpty ? metrics.first : null;
  }

  Future<void> deleteHealthMetric(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'health_metrics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllHealthMetrics() async {
    final db = await _dbService.database;
    await db.delete('health_metrics');
  }

  Future<Map<HealthMetricType, HealthMetric?>> getLatestMetrics() async {
    final db = await _dbService.database;
    final metrics = <HealthMetricType, HealthMetric?>{};

    for (final type in HealthMetricType.values) {
      final latest = await getLatestHealthMetric(type);
      metrics[type] = latest;
    }

    return metrics;
  }
}




