import 'package:flutter/material.dart';
import '../models/stats.dart';

class StatsViewModel extends ChangeNotifier {
  final List<DailyStats> weeklyStats = [
    DailyStats(date: DateTime.now(), minutes: 60, tasksCompleted: 3),
    DailyStats(date: DateTime.now().subtract(const Duration(days: 1)), minutes: 40, tasksCompleted: 2),
    DailyStats(date: DateTime.now().subtract(const Duration(days: 2)), minutes: 20, tasksCompleted: 1),
  ];

  void recordSession(int minutes) {
    weeklyStats[0] = DailyStats(
      date: weeklyStats[0].date,
      minutes: weeklyStats[0].minutes + minutes,
      tasksCompleted: weeklyStats[0].tasksCompleted + 1,
    );
    notifyListeners();
  }
}
