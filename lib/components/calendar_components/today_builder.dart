import 'package:flutter/material.dart';

class TodayBuilder extends StatelessWidget {
  const TodayBuilder({
    super.key,
    required this.context,
    required this.day,
    required this.focusedDay,
    required this.isSameDay,
  });

  final BuildContext context;
  final DateTime day;
  final DateTime focusedDay;
  final bool isSameDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSameDay ? Colors.black : Colors.green),
      ),
      child: Center(child: Text("${day.day}")),
    );
  }
}
