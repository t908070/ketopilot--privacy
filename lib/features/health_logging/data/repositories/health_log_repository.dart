import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../../../../core/database/database_service.dart';

class HealthLog {
  final String id;
  final DateTime timestamp;
  final int energyLevel;
  final int moodLevel;
  final int sleepQuality;
  final int mentalClarity;
  final List<String> symptoms;
  final String? notes;

  HealthLog({
    required this.id,
    required this.timestamp,
    required this.energyLevel,
    required this.moodLevel,
    required this.sleepQuality,
    required this.mentalClarity,
    required this.symptoms,
    this.notes,
  });
}

class HealthLogRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<void> saveHealthLog(HealthLog log) async {
    final db = await _dbService.database;
    await db.insert(
      'health_logs',
      {
        'id': log.id,
        'timestamp': log.timestamp.millisecondsSinceEpoch,
        'energy_level': log.energyLevel,
        'mood_level': log.moodLevel,
        'sleep_quality': log.sleepQuality,
        'mental_clarity': log.mentalClarity,
        'symptoms': jsonEncode(log.symptoms),
        'notes': log.notes,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HealthLog>> getHealthLogs({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final db = await _dbService.database;

    String query = 'SELECT * FROM health_logs WHERE 1=1';
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

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, args);

    return maps.map((map) {
      final symptomsJson = map['symptoms'] as String?;
      final symptoms = symptomsJson != null
          ? List<String>.from(jsonDecode(symptomsJson))
          : <String>[];

      return HealthLog(
        id: map['id'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
        energyLevel: map['energy_level'] as int,
        moodLevel: map['mood_level'] as int,
        sleepQuality: map['sleep_quality'] as int,
        mentalClarity: map['mental_clarity'] as int,
        symptoms: symptoms,
        notes: map['notes'] as String?,
      );
    }).toList();
  }

  Future<void> deleteHealthLog(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'health_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}




