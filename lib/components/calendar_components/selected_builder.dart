import 'package:flutter/material.dart';

class SelectedBuilder extends StatelessWidget {
  const SelectedBuilder({
    super.key,
    required this.context,
    required this.day,
    required this.focusedDay,
  });
  final BuildContext context;
  final DateTime day;
  final DateTime focusedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text("${day.day}")),
    );
  }
}
