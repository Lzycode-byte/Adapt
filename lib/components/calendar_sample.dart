import 'package:adapt/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarSample extends StatefulWidget {
  const CalendarSample({super.key});

  @override
  State<CalendarSample> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarSample> {
  DateTime? selectedDate;
  final Map<DateTime, int> habitData = {
    DateTime(2026, 4, 17): 2,
    DateTime(2026, 4, 24): 1,
    DateTime(2026, 4, 5): 3,
  };

  Color getColor(int value) {
    switch (value) {
      case 1:
        return Colors.green.shade200;
      case 2:
        return Colors.green.shade400;
      case 3:
        return Colors.green.shade700;
      default:
        return Colors.green.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      onDaySelected: (day, someday) {
        setState(() {
          selectedDate = day;
        });
      },
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: DateTime.now(),
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, day, focusedDay) {
          final isToday = isSameDay(day, DateTime.now());
          final isSelected = isSameDay(day, selectedDate);
          return SizedBox.expand(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: isSelected ? Border.all(color: Colors.blue) : null,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isToday
                        ? [BoxShadow(color: Colors.black.withValues())]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(top: 2, right: 2, child: circle),
              ],
            ),
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          final normalized = DateTime(day.year, day.month, day.day);
          final value = habitData[normalized] ?? 0;
          final isSelected = isSameDay(day, selectedDate);
          return Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: getColor(value),
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
              // optional glow
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget circle = Container(
  height: 8,
  width: 8,
  decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
);
