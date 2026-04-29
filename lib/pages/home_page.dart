import 'package:adapt/components/habit_components/habit_tile.dart';
import 'package:adapt/components/heatmap.dart';
import 'package:adapt/components/home_drawer.dart';
import 'package:adapt/database/habit_database.dart';
import 'package:adapt/models/habit.dart';
import 'package:adapt/utils/habit_util.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  void createHewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GifView.asset(
              "assets/image_assets/mahoraga.gif",
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Create New Habit"),
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
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().addHabit(newHabitName);

              Navigator.pop(context);

              textController.clear();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void checkOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
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
              String newHabitName = textController.text;
              context.read<HabitDatabase>().updateHabitName(
                habit.id,
                newHabitName,
              );

              Navigator.pop(context);

              textController.clear();
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Adapt"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      drawer: HomeDrawer(),
      // body: SafeArea(child: Calendar()),
      body: ListView(children: [_buildHeatMap(), _buildHabitList()]),
      floatingActionButton: FloatingActionButton(
        onPressed: createHewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Heatmap(
            onClick: _showHabitsForDate,
            startDate: snapshot.data!,
            datasets: prepHeatMapDatabase(currentHabits),
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

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompleted(habit.completedDays);
        return HabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }

  void _showHabitsForDate(DateTime date) {
    final habitDatabase = context.read<HabitDatabase>();
    final List<Habit> currentHabits = habitDatabase.currentHabits;

    // Normalize the clicked date (remove time component)
    final normalizedClickedDate = DateTime(date.year, date.month, date.day);

    // Prepare habit data with completion status
    final List<Map<String, dynamic>> habitsWithStatus = currentHabits.map((
      habit,
    ) {
      final bool isCompleted = habit.completedDays.any((completedDate) {
        final normalizedCompletedDate = DateTime(
          completedDate.year,
          completedDate.month,
          completedDate.day,
        );
        return normalizedCompletedDate == normalizedClickedDate;
      });

      return {'habit': habit, 'isCompleted': isCompleted};
    }).toList();
    // Show bottom sheet with all habits and their status
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habits for ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: habitsWithStatus.length,
                itemBuilder: (context, index) {
                  final item = habitsWithStatus[index];
                  final habit = item['habit'] as Habit;
                  final bool isCompleted = item['isCompleted'] as bool;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        // Completion status indicator
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isCompleted ? Colors.green : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        // Habit name with optional styling for completed
                        Expanded(
                          child: Text(
                            habit.name,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: isCompleted
                                      ? Colors.green.shade700
                                      : null,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // const SizedBox(height: 24),
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
    );
  }
}
