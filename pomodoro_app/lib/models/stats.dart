import 'package:cloud_firestore/cloud_firestore.dart';

class DailyStats {
  final DateTime date;
  final int minutes;
  final int tasksCompleted;

  DailyStats({
    required this.date,
    required this.minutes,
    required this.tasksCompleted,
  });

  factory DailyStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyStats(
      date: (data['date'] as Timestamp).toDate(),
      minutes: data['minutes'] ?? 0,
      tasksCompleted: data['tasksCompleted'] ?? 0,
    );
  }

  // Convert DailyStats to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date), 
      'minutes': minutes,
      'tasksCompleted': tasksCompleted,
    };
  }
}