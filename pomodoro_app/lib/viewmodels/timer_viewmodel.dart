import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerViewModel extends ChangeNotifier {
  int remainingSeconds = 25 * 60;
  bool isRunning = false;
  Timer? _timer;

  void start() {
    if (isRunning) return;
    isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds == 0) {
        stop();
      } else {
        remainingSeconds--;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  void stop() {
    isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    remainingSeconds = 25 * 60;
    notifyListeners();
  }

  String get formatted =>
      "${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}";
}
