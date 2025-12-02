import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> tasks = [
    Task(name: "Email Check", description: "Reply to urgent client emails", minutes: 20),
    Task(name: "Code Review", description: "Review PR #42 and #45", minutes: 20),
  ];

  void addTask(String name, String description, int minutes) {
    tasks.add(Task(name: name, description: description, minutes: minutes));
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  String get totalWorkTime {
    int totalMinutes = tasks.fold(0, (sum, task) => sum + task.minutes);
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return "${hours}:${minutes.toString().padLeft(2, '0')}:00";
  }

  String get totalBreakTime {
    int totalBreakMinutes = tasks.length * 5;
    return "${totalBreakMinutes}:00";
  }
}