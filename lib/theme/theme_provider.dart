import 'package:adapt/models/app_settings.dart';
import 'package:adapt/theme/dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:adapt/theme/light_mode.dart';
import 'package:isar_community/isar.dart';
import '../database/habit_database.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeProvider() {
    _loadThemeFromIsar();
  }
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
    _saveThemeToIsar();
  }

  Future<void> _loadThemeFromIsar() async {
    final settings = await HabitDatabase.isar.appSettings.where().findFirst();
    if (settings?.currentMode == true) {
      _themeData = darkMode;
      notifyListeners();
    }
  }

  Future<void> _saveThemeToIsar() async {
    final settings = await HabitDatabase.isar.appSettings.where().findFirst();
    if (settings != null) {
      await HabitDatabase.isar.writeTxn(() async {
        settings.currentMode = isDarkMode;
        await HabitDatabase.isar.appSettings.put(settings);
      });
    }
  }
}
