import 'package:adapt/components/calendar_components/default_builder.dart';
import 'package:adapt/components/calendar_components/selected_builder.dart';
import 'package:adapt/components/calendar_components/today_builder.dart';
import 'package:adapt/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {


        }
        ,
        selectedBuilder: (context, day, focusedDay) {
          return SelectedBuilder(
            context: context,
            day: day,
            focusedDay: focusedDay,
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return TodayBuilder(
            context: context,
            day: day,
            focusedDay: focusedDay,
            isSameDay: isSameDay(_selectedDay, day),
          );
        },

        defaultBuilder: (context, day, focusedDay) {
          return DefaultBuilder(
            context: context,
            day: day,
            focusedDay: focusedDay,
          );
        },
      ),
    );
  }
}
