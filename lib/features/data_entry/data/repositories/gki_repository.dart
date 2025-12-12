import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/health_metric.dart';

class GkiRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  GkiStatus _calculateGkiStatus(double gki) {
    if (gki <= AppConstants.optimalGkiUpper) {
      return GkiStatus.optimal;
    } else if (gki <= 6.0) {
      return GkiStatus.therapeutic;
    } else if (gki <= 9.0) {
      return GkiStatus.moderate;
    } else if (gki <= 12.0) {
      return GkiStatus.elevated;
    } else {
      return GkiStatus.high;
    }
  }

  double calculateGKI(double glucose, double ketones) {
    if (ketones == 0) return double.infinity;
    return glucose / (ketones * 18.0);
  }

  Future<void> saveGKI({
    required String id,
    required DateTime timestamp,
    required double glucose,
    required double ketones,
  }) async {
    final gkiValue = calculateGKI(glucose, ketones);
    final status = _calculateGkiStatus(gkiValue);

    final db = await _dbService.database;
    await db.insert(
      'gki_records',
      {
        'id': id,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'glucose': glucose,
        'ketones': ketones,
        'gki_value': gkiValue,
        'status': status.name,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getGkiRecords({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final db = await _dbService.database;

    String query = 'SELECT * FROM gki_records WHERE 1=1';
    List<dynamic> args = [];

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

    return await db.rawQuery(query, args);
  }

  Future<Map<String, dynamic>?> getLatestGKI() async {
    final records = await getGkiRecords(limit: 1);
    return records.isNotEmpty ? records.first : null;
  }
}




