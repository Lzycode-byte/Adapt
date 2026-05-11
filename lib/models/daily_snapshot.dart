// lib/models/daily_snapshot.dart
import 'package:isar_community/isar.dart';
part 'daily_snapshot.g.dart';

@Collection()
class DailySnapshot {
  Id id = Isar.autoIncrement;

  late DateTime date; // normalized (no time)

  // Store as parallel lists (Isar doesn't support List<Map>)
  List<int> habitIds = [];
  List<String> habitNames = [];
  List<bool> completionStatus = [];
}
