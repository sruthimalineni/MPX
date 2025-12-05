import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskViewModel extends ChangeNotifier {
  final List<Task> tasks = [];

  void addTask(String name, String description, int minutes) {
    tasks.add(Task(name: name, description: description, minutes: minutes));
    notifyListeners();
  }

  void updateTask(int index, String name, String description, int minutes) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = Task(name: name, description: description, minutes: minutes);
      notifyListeners();
    }
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