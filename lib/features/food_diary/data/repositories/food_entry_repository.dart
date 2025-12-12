import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_service.dart';
import '../../domain/entities/food_entry.dart';

class FoodEntryRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<void> saveFoodEntry(FoodEntry entry) async {
    final db = await _dbService.database;
    await db.insert(
      'food_entries',
      {
        'id': entry.id,
        'name': entry.name,
        'timestamp': entry.timestamp.millisecondsSinceEpoch,
        'serving_size': entry.servingSize,
        'serving_unit': entry.servingUnit,
        'carbs': entry.macros.carbs,
        'protein': entry.macros.protein,
        'fat': entry.macros.fat,
        'fiber': entry.macros.fiber,
        'net_carbs': entry.macros.netCarbs,
        'calories': entry.macros.calories,
        'notes': entry.notes,
        'brand': entry.brand,
        'meal_type': entry.mealType,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodEntry>> getFoodEntries({
    DateTime? startDate,
    DateTime? endDate,
    String? mealType,
    int? limit,
  }) async {
    final db = await _dbService.database;

    String query = 'SELECT * FROM food_entries WHERE 1=1';
    List<dynamic> args = [];

    if (startDate != null) {
      query += ' AND timestamp >= ?';
      args.add(startDate.millisecondsSinceEpoch);
    }

    if (endDate != null) {
      query += ' AND timestamp <= ?';
      args.add(endDate.millisecondsSinceEpoch);
    }

    if (mealType != null) {
      query += ' AND meal_type = ?';
      args.add(mealType);
    }

    query += ' ORDER BY timestamp DESC';

    if (limit != null) {
      query += ' LIMIT ?';
      args.add(limit);
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query, args);

    return maps.map((map) => FoodEntry(
      id: map['id'] as String,
      name: map['name'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      servingSize: map['serving_size'] as double,
      servingUnit: map['serving_unit'] as String,
      macros: Macronutrients(
        carbs: map['carbs'] as double,
        protein: map['protein'] as double,
        fat: map['fat'] as double,
        fiber: map['fiber'] as double,
        netCarbs: map['net_carbs'] as double,
        calories: map['calories'] as double,
      ),
      notes: map['notes'] as String?,
      brand: map['brand'] as String?,
      mealType: map['meal_type'] as String?,
    )).toList();
  }

  Future<Macronutrients> getDailyMacros(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final entries = await getFoodEntries(
      startDate: startOfDay,
      endDate: endOfDay,
    );

    double carbs = 0;
    double protein = 0;
    double fat = 0;
    double fiber = 0;
    double calories = 0;

    for (final entry in entries) {
      carbs += entry.macros.carbs;
      protein += entry.macros.protein;
      fat += entry.macros.fat;
      fiber += entry.macros.fiber;
      calories += entry.macros.calories;
    }

    return Macronutrients(
      carbs: carbs,
      protein: protein,
      fat: fat,
      fiber: fiber,
      netCarbs: carbs - fiber,
      calories: calories,
    );
  }

  Future<void> deleteFoodEntry(String id) async {
    final db = await _dbService.database;
    await db.delete(
      'food_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllFoodEntries() async {
    final db = await _dbService.database;
    await db.delete('food_entries');
  }
}




