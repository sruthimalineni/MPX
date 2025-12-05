import 'package:flutter/material.dart';
import '../models/stats.dart';

class StatsViewModel extends ChangeNotifier {
  // Renamed from weeklyStats to monthlyStats and initialized as empty
  final List<DailyStats> monthlyStats = []; 

  // Updated method for recording a completed task session
  void recordSession(int minutes) {
    final now = DateTime.now();
    
    // Find today's stats entry using indexWhere
    int todayIndex = monthlyStats.indexWhere(
      // Compare year, month, and day only
      (s) => s.date.year == now.year && s.date.month == now.month && s.date.day == now.day,
    );

    if (todayIndex != -1) {
      // Update existing entry
      final today = monthlyStats[todayIndex];
      monthlyStats[todayIndex] = DailyStats(
        date: today.date,
        minutes: today.minutes + minutes,
        tasksCompleted: today.tasksCompleted + 1,
      );
    } else {
      // Add new entry for today (time is normalized to midnight for consistency)
      monthlyStats.insert(0, DailyStats(
        date: DateTime(now.year, now.month, now.day), 
        minutes: minutes, 
        tasksCompleted: 1
      ));
    }
    
    // In a real app, this is where you would also update Firebase
    notifyListeners();
  }
  
  Future<void> fetchStats() async {
    // 1. Initialize Firebase (e.g., Firebase.initializeApp())
    // 2. Query Firestore/Realtime Database for your 'daily_stats' collection
    // 3. Convert the fetched documents into a List<DailyStats>
    // 4. Update the 'monthlyStats' list with fetched data
    debugPrint("Placeholder: Fetching stats from Firebase...");
    // Example of setting data after fetch: monthlyStats = fetchedData;
    notifyListeners();
  }
}