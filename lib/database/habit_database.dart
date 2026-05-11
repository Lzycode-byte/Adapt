import 'package:adapt/models/app_settings.dart';
import 'package:adapt/models/daily_snapshot.dart';
import 'package:adapt/models/habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // ── In-memory cache ────────────────────────────────────────────────────────
  final List<Habit> currentHabits = [];
  Map<DateTime, int> heatmapDataset = {};
  DateTime? firstDateCache;
  bool _initialized = false;

  // ── Init ───────────────────────────────────────────────────────────────────

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
      DailySnapshotSchema,
    ], directory: dir.path);
  }

  /// Call once on app start — loads first date, rebuilds today's snapshot,
  /// then warms the heatmap cache. Safe to call multiple times.
  Future<void> initCache() async {
    if (_initialized) return;

    // 1. Load or create first launch date
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
      firstDateCache = settings.firstLaunchDate;
    } else {
      firstDateCache = existingSettings.firstLaunchDate;
    }

    // 2. Always rewrite today's snapshot so completedDays from
    //    Isar are reflected even without a toggle after relaunch
    await _writeTodaySnapshot();

    // 3. Build heatmap dataset from all snapshots
    await _rebuildHeatmapDataset();

    _initialized = true;
    notifyListeners();
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  Future<void> addHabit(String name) async {
    final newHabit = Habit()..name = name;
    await isar.writeTxn(() => isar.habits.put(newHabit));
    await _writeTodaySnapshot();
    await readHabits();
  }

  Future<void> readHabits() async {
    final fetched = await isar.habits.where().findAll();
    currentHabits
      ..clear()
      ..addAll(fetched);
    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        if (isCompleted) {
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere(
            (d) =>
                d.year == today.year &&
                d.month == today.month &&
                d.day == today.day,
          );
        }
        await isar.habits.put(habit);
      });
    }
    await _writeTodaySnapshot();
    await readHabits();
  }

  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    await readHabits();
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() => isar.habits.delete(id));
    await _writeTodaySnapshot();
    await readHabits();
  }

  Future<void> deleteAllHabits(List<int> ids) async {
    await isar.writeTxn(() => isar.habits.deleteAll(ids));
    await _writeTodaySnapshot();
    await readHabits();
  }

  // ── Snapshot ───────────────────────────────────────────────────────────────

  /// Writes today's snapshot based on current Isar habit state,
  /// then rebuilds the in-memory heatmap dataset.
  Future<void> _writeTodaySnapshot() async {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final habits = await isar.habits.where().findAll();

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

    await _rebuildHeatmapDataset();
  }

  /// Rebuilds heatmap dataset from all snapshots in Isar.
  Future<void> _rebuildHeatmapDataset() async {
    final snapshots = await isar.dailySnapshots.where().findAll();
    final Map<DateTime, int> dataset = {};

    for (final snapshot in snapshots) {
      final count = snapshot.completionStatus.where((c) => c).length;
      if (count > 0) dataset[snapshot.date] = count;
    }

    heatmapDataset = dataset;
  }

  /// Get snapshot for a specific date (used by heatmap bottom sheet).
  Future<DailySnapshot?> getSnapshotForDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    return await isar.dailySnapshots
        .filter()
        .dateEqualTo(normalized)
        .findFirst();
  }

  /// Get all snapshots (used by analytics).
  Future<List<DailySnapshot>> getAllSnapshots() async {
    return await isar.dailySnapshots.where().findAll();
  }
}
