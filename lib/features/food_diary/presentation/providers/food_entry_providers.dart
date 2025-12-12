import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/food_entry_repository.dart';
import '../../domain/entities/food_entry.dart';

final foodEntryRepositoryProvider = Provider<FoodEntryRepository>((ref) {
  return FoodEntryRepository();
});

final todayFoodEntriesProvider = FutureProvider<List<FoodEntry>>((ref) async {
  final repository = ref.watch(foodEntryRepositoryProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  
  return await repository.getFoodEntries(
    startDate: startOfDay,
    endDate: endOfDay,
  );
});

final todayMacrosProvider = FutureProvider<Macronutrients>((ref) async {
  final repository = ref.watch(foodEntryRepositoryProvider);
  return await repository.getDailyMacros(DateTime.now());
});

final recentFoodEntriesProvider = FutureProvider.family<List<FoodEntry>, int>((ref, limit) async {
  final repository = ref.watch(foodEntryRepositoryProvider);
  return await repository.getFoodEntries(limit: limit);
});




