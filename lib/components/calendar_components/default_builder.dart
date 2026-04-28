import 'package:flutter/material.dart';

class DefaultBuilder extends StatelessWidget {
  const DefaultBuilder({
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
      margin: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        // color: Colors.green.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text('${day.day}')),
    );
  }
}
