import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerViewModel extends ChangeNotifier {
  
  static const int workDuration = 25 * 60; 
  static const int breakDuration = 5 * 60;

  int remainingSeconds = workDuration;
  int currentTotalDuration = workDuration; 
  
  bool isRunning = false;
  bool isBreak = false;
  Timer? _timer;

  void start() {
    if (isRunning) return;
    isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds == 0) {
        _handleTimerCompletion();
      } else {
        remainingSeconds--;
        notifyListeners();
      }
    });
  }

  void _handleTimerCompletion() {
    _timer?.cancel();
    
    if (!isBreak) {
      isBreak = true;
      remainingSeconds = breakDuration;
      currentTotalDuration = breakDuration;
      
      isRunning = false; 
    } else {
      isBreak = false;
      remainingSeconds = workDuration;
      currentTotalDuration = workDuration;
      
      isRunning = false; 
    }
    notifyListeners();
  }

  void stop() {
    isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    stop();
    isBreak = false;
    remainingSeconds = workDuration;
    currentTotalDuration = workDuration; 
    notifyListeners();
  }

  String get formatted =>
      "${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}";

  double get progressPercentage {
    if (currentTotalDuration == 0) return 1.0;
    int passed = currentTotalDuration - remainingSeconds;
    return passed / currentTotalDuration;
  }
}