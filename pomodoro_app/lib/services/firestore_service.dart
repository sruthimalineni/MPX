import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/stats.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath = 'daily_stats';

  /// Fetch all stats, sorted by date (newest first)
  Future<List<DailyStats>> fetchAllStats() async {
    try {
      final snapshot = await _db
          .collection(collectionPath)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) => DailyStats.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching stats: $e");
      return [];
    }
  }

  /// Atomically updates today's stats.
  /// If the document doesn't exist, it creates it.
  /// If it does exist, it adds the new minutes to the existing total.
  Future<void> updateDailyStats(int minutesToAdd) async {
    final now = DateTime.now();
    
    // Create a unique ID for date of use 
    // Prevents creating duplicate entries for the same day.
    final String docId = DateFormat('yyyy-MM-dd').format(now);
    final DateTime todayMidnight = DateTime(now.year, now.month, now.day);

    final docRef = _db.collection(collectionPath).doc(docId);

    try {
      await docRef.set({
        'date': Timestamp.fromDate(todayMidnight), 
        'minutes': FieldValue.increment(minutesToAdd),
        'tasksCompleted': FieldValue.increment(1),
      }, SetOptions(merge: true));
      
    } catch (e) {
      debugPrint("Error updating daily stats: $e");
      rethrow; 
    }
  }
}