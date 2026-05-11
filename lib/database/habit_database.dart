import 'package:adapt/models/app_settings.dart';
import 'package:adapt/models/daily_snapshot.dart';
import 'package:adapt/models/habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
      DailySnapshotSchema,
    ], directory: dir.path);
  }

  // Save firstLaunch date for heatmap
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //Get firstDate of startup
  Future<DateTime?> getFirstDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  final List<Habit> currentHabits = [];

  // CREATE
  Future<void> addHabit(String name) async {
    final newHabit = Habit()..name = name;
    await isar.writeTxn(() => isar.habits.put(newHabit));
    await saveDailySnapshot();
    readHabits();
  }

  //READ
  Future<void> readHabits() async {
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    notifyListeners();
  }

  //UPDATE Habit completion
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        await isar.habits.put(habit);
      });
    }
    await saveDailySnapshot();
    readHabits();
  }

  // UPDATE Habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  // DELETE
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    await saveDailySnapshot();
    readHabits();
  }

  // Delete all
  Future<void> deleteAllHabits(List<int> ids) async {
    await isar.writeTxn(() async {
      await isar.habits.deleteAll(ids);
    });
  }

  /// Call this whenever habit completion changes (in updateHabitCompletion)
  Future<void> saveDailySnapshot() async {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final habits = await isar.habits.where().findAll();

    // Build snapshot data
    final ids = <int>[];
    final names = <String>[];
    final completions = <bool>[];

    for (final habit in habits) {
      ids.add(habit.id);
      names.add(habit.name);
      completions.add(
        habit.completedDays.any(
          (d) =>
              d.year == today.year &&
              d.month == today.month &&
              d.day == today.day,
        ),
      );
    }

    // Check if snapshot for today already exists
    final existing = await isar.dailySnapshots
        .filter()
        .dateEqualTo(normalizedToday)
        .findFirst();

    await isar.writeTxn(() async {
      final snapshot = existing ?? DailySnapshot();
      snapshot.date = normalizedToday;
      snapshot.habitIds = ids;
      snapshot.habitNames = names;
      snapshot.completionStatus = completions;
      await isar.dailySnapshots.put(snapshot);
    });
  }

  /// Get snapshot for a specific date (used by heatmap bottom sheet)
  Future<DailySnapshot?> getSnapshotForDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    return await isar.dailySnapshots
        .filter()
        .dateEqualTo(normalized)
        .findFirst();
  }

  /// Check if a snapshot exists for today (call on app start)
  Future<void> ensureTodaySnapshot() async {
    final today = DateTime.now();
    final normalized = DateTime(today.year, today.month, today.day);
    final existing = await isar.dailySnapshots
        .filter()
        .dateEqualTo(normalized)
        .findFirst();

    // If no snapshot yet today, create one with current state
    if (existing == null) {
      await saveDailySnapshot();
    }
  }

  /// Returns heatmap dataset from all saved snapshots (persists deleted habits)
  Future<Map<DateTime, int>> getSnapshotHeatmapData() async {
    final snapshots = await isar.dailySnapshots.where().findAll();
    final Map<DateTime, int> dataset = {};

    for (final snapshot in snapshots) {
      final completedCount = snapshot.completionStatus
          .where((c) => c == true)
          .length;
      if (completedCount > 0) {
        dataset[snapshot.date] = completedCount;
      }
    }

    return dataset;
  }

  Future<List<DailySnapshot>> getAllSnapshots() async {
    return await isar.dailySnapshots.where().findAll();
  }
}
