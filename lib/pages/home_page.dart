import 'package:adapt/components/habit_components/habit_tile.dart';
import 'package:adapt/components/heatmap.dart';
import 'package:adapt/database/habit_database.dart';
import 'package:adapt/models/habit.dart';
import 'package:adapt/utils/habit_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutorial_overlay/flutter_tutorial_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../components/scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Object?>> _heatmapFuture;
  final GlobalKey _floatingButtonKey = GlobalKey();
  final GlobalKey _habitTile = GlobalKey();
  final GlobalKey _heatMap = GlobalKey();

  @override
  void initState() {
    final db = Provider.of<HabitDatabase>(context, listen: false);

    db.readHabits();

    super.initState();
    _refreshHeatmap();
  }

  void _startTutorial() {
    final steps = [
      TutorialStep(
        targetKey: _floatingButtonKey,
        description: "Tap the + button to adapt a new habit",
        title: "Welcome!",
      ),
      TutorialStep(
        targetKey: _habitTile,
        description: "Slide the habits you created to left to edit/delete",
        title: "This is part is where your habit goes!",
      ),
      TutorialStep(
        targetKey: _heatMap,
        description: "To see your habit status on the date",
        title: "Tap on the date!",
      ),
    ];
    final tutorial = TutorialOverlay(context: context, steps: steps);

    tutorial.show();
  }

  void _refreshHeatmap() {
    final db = Provider.of<HabitDatabase>(context, listen: false);
    setState(() {
      _heatmapFuture = Future.wait([
        db.getFirstDate(),
        db.getSnapshotHeatmapData(),
      ]);
    });
  }

  final TextEditingController textController = TextEditingController();

  void createHewHabit() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                "assets/json_assets/2.json",
                height: 140,
                width: 140,
                fit: BoxFit.contain,
              ),
              TextField(
                controller: textController,
                onChanged: (_) => setDialogState(() {}),
                decoration: const InputDecoration(
                  hintText: "You're adapting a new habit",
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: const Text("Cancel"),
            ),
            MaterialButton(
              onPressed: textController.text.trim().isEmpty
                  ? null
                  : () {
                      String newHabitName = textController.text;
                      context.read<HabitDatabase>().addHabit(newHabitName);

                      Navigator.pop(context);

                      textController.clear();
                    },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  // void checkOnOff(bool? value, Habit habit) {
  //   if (value != null) {
  //     context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
  //   }
  // }

  void checkOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value).then(
        (_) {
          _refreshHeatmap(); // ADD — refresh after toggle
        },
      );
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Update Habit name"),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              textController.text.trim().isEmpty
                  ? null
                  : () {
                      String newHabitName = textController.text;
                      context.read<HabitDatabase>().updateHabitName(
                        habit.id,
                        newHabitName,
                      );

                      Navigator.pop(context);

                      textController.clear();
                    };
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              _refreshHeatmap();

              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "Adapt",
      actions: [
        IconButton(
          onPressed: _startTutorial,
          icon: Icon(CupertinoIcons.question_circle),
        ),
      ],
      // body: SafeArea(child: Calendar()),
      body: ListView(
        children: [
          _buildHeatMap(),
          Divider(endIndent: 20, indent: 30, thickness: 0.5),
          SizedBox(height: 10),
          _buildHabitList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: _floatingButtonKey,
        onPressed: createHewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();
    final List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<List<Object?>>(
      future: _heatmapFuture,
      // future: Future.wait([
      //   habitDatabase.getFirstDate(),
      //   habitDatabase.getSnapshotHeatmapData(), // ADD
      // ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final startDate = snapshot.data![0] as DateTime?;
          final snapshotDataset = snapshot.data![1] as Map<DateTime, int>;

          if (startDate == null) return Container();

          // Live data for today's current habits
          final liveDataset = prepHeatMapDatabase(currentHabits);

          // Merge: snapshot as base, live data fills/overwrites today
          final mergedDataset = Map<DateTime, int>.from(snapshotDataset);
          liveDataset.forEach((date, count) {
            mergedDataset[date] = count; // live overwrites for today
          });

          return Heatmap(
            key: _heatMap,
            onClick: (date) async => _showHabitsForDate(date),
            startDate: startDate,
            datasets: mergedDataset,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return currentHabits.isNotEmpty
        ? ListView.builder(
            key: _habitTile,
            itemCount: currentHabits.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final habit = currentHabits[index];
              bool isCompletedToday = isHabitCompleted(habit.completedDays);
              return HabitTile(
                isCompleted: isCompletedToday,
                text: habit.name,
                completedDays: habit.completedDays,
                onChanged: (value) => checkOnOff(value, habit),
                editHabit: (context) => editHabitBox(habit),
                deleteHabit: (context) => deleteHabitBox(habit),
              );
            },
          )
        : Center(key: _habitTile, child: Text("Create your first habit!"));
  }

  void _showHabitsForDate(DateTime date) async {
    final habitDatabase = context.read<HabitDatabase>();
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    List<Map<String, dynamic>> habitsWithStatus = [];

    // Always try snapshot first (works for both past AND today)
    final snapshot = await habitDatabase.getSnapshotForDate(normalizedDate);

    if (snapshot != null) {
      for (int i = 0; i < snapshot.habitIds.length; i++) {
        habitsWithStatus.add({
          'name': snapshot.habitNames[i],
          'isCompleted': snapshot.completionStatus[i],
        });
      }
    } else if (normalizedDate == today) {
      // Fallback: snapshot not yet created (first launch, no habit toggled yet)
      for (final habit in habitDatabase.currentHabits) {
        habitsWithStatus.add({
          'name': habit.name,
          'isCompleted': habit.completedDays.any(
            (d) =>
                d.year == today.year &&
                d.month == today.month &&
                d.day == today.day,
          ),
        });
      }
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // lets the sheet grow taller if needed
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.25,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                '${normalizedDate.day.toString().padLeft(2, '0')} '
                '${_monthName(normalizedDate.month)} '
                '${normalizedDate.year}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              // Completion summary
              if (habitsWithStatus.isNotEmpty)
                Text(
                  '${habitsWithStatus.where((h) => h['isCompleted'] == true).length}'
                  ' / ${habitsWithStatus.length} completed',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: habitsWithStatus.isEmpty
                    ? const Center(child: Text("No habit data for this date."))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: habitsWithStatus.length,
                        itemBuilder: (context, index) {
                          final item = habitsWithStatus[index];
                          final String name = item['name'] as String;
                          final bool isCompleted = item['isCompleted'] as bool;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(
                                  isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: isCompleted
                                      ? Colors.green
                                      : Colors.grey,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: isCompleted
                                              ? Colors.green.shade700
                                              : Colors.grey.shade600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper
  String _monthName(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month - 1];
  }
}
