import 'package:adapt/utils/habit_util.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Streak extends StatelessWidget {
  const Streak({super.key, required this.completedDays});
  final List<DateTime> completedDays;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            "assets/json_assets/Fire.json",
            fit: BoxFit.contain,
            width: 80,
            height: 80,
          ),
          Align(
            alignment: Alignment(0, 0.6), // shift text toward bottom of flame
            child: Text(
              "${habitStreak(completedDays)}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 7, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
