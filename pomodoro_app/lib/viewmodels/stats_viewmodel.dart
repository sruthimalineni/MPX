import 'package:flutter/material.dart';
import '../models/stats.dart';
import '../services/firestore_service.dart'; 

class StatsViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  
  List<DailyStats> monthlyStats = []; 

  StatsViewModel() {
    fetchStats();
  }

  Future<void> recordSession(int minutes) async {
    await _firestoreService.updateDailyStats(minutes);
    await fetchStats(); 
  }
  
  Future<void> fetchStats() async {
    final stats = await _firestoreService.fetchAllStats();
    monthlyStats = stats;
    notifyListeners();
  }
  

  List<double> get monthlyTimeValues {
    Map<int, double> monthMap = {};
    for (int i = 1; i <= 12; i++) monthMap[i] = 0.0;

    for (var stat in monthlyStats) {
      monthMap[stat.date.month] = (monthMap[stat.date.month] ?? 0) + stat.minutes;
    }
    return monthMap.values.toList();
  }

  List<double> get monthlyTaskValues {
    Map<int, double> monthMap = {};
    for (int i = 1; i <= 12; i++) monthMap[i] = 0.0;

    for (var stat in monthlyStats) {
      monthMap[stat.date.month] = (monthMap[stat.date.month] ?? 0) + stat.tasksCompleted;
    }
    return monthMap.values.toList();
  }
}