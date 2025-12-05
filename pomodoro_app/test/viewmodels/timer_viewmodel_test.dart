import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_mpv_demo/viewmodels/timer_viewmodel.dart';

void main() {
  group('TimerViewModel Unit Tests', () {
    late TimerViewModel timerViewModel;

    setUp(() {
      timerViewModel = TimerViewModel();
    });

    tearDown(() {
      timerViewModel.dispose();
    });

    test('TimerViewModel initializes with correct default values', () {
      // Verify initial state
      expect(timerViewModel.remainingSeconds, equals(25 * 60)); // 1500 seconds (25 minutes)
      expect(timerViewModel.isRunning, false);
      expect(timerViewModel.isBreak, false);
      expect(timerViewModel.currentTotalDuration, equals(25 * 60));
    });

    test('Formatted time displays correctly', () {
      timerViewModel.remainingSeconds = 1505; // 25:05
      expect(timerViewModel.formatted, equals('25:05'));

      timerViewModel.remainingSeconds = 65; // 01:05
      expect(timerViewModel.formatted, equals('01:05'));

      timerViewModel.remainingSeconds = 5; // 00:05
      expect(timerViewModel.formatted, equals('00:05'));

      timerViewModel.remainingSeconds = 0; // 00:00
      expect(timerViewModel.formatted, equals('00:00'));
    });

    test('Progress percentage calculates correctly', () {
      // Initial progress should be 0
      timerViewModel.remainingSeconds = 1500;
      timerViewModel.currentTotalDuration = 1500;
      expect(timerViewModel.progressPercentage, equals(0.0));

      timerViewModel.remainingSeconds = 750;
      expect(timerViewModel.progressPercentage, equals(0.5));

      timerViewModel.remainingSeconds = 0;
      expect(timerViewModel.progressPercentage, equals(1.0));
    });

    test('Start method sets isRunning to true', () {
      expect(timerViewModel.isRunning, false);
      
      timerViewModel.start();
      
      expect(timerViewModel.isRunning, true);
      
      timerViewModel.stop();
    });

    test('Start method is idempotent (multiple calls do not cause issues)', () {
      timerViewModel.start();
      expect(timerViewModel.isRunning, true);
      
      timerViewModel.start();
      expect(timerViewModel.isRunning, true);
      
      timerViewModel.stop();
    });

    test('Timer counts down correctly', () async {
      final initialSeconds = timerViewModel.remainingSeconds;
      
      timerViewModel.start();
      
      // Wait for 3 seconds to pass
      await Future.delayed(const Duration(seconds: 3));
      
      // Stop the timer
      timerViewModel.stop();
      
      // Verify that time has decreased (should be around 3 seconds less)
      expect(timerViewModel.remainingSeconds, lessThan(initialSeconds));
      expect(timerViewModel.remainingSeconds, greaterThanOrEqualTo(initialSeconds - 4));
    });

    test('Stop stops the timer and countdown', () async {
      timerViewModel.start();
      expect(timerViewModel.isRunning, true);
      
      await Future.delayed(const Duration(seconds: 1));
      
      timerViewModel.stop();
      expect(timerViewModel.isRunning, false);
      
      final secondsAfterStop = timerViewModel.remainingSeconds;
      
      await Future.delayed(const Duration(seconds: 2));
      
      expect(timerViewModel.remainingSeconds, equals(secondsAfterStop));
    });

    test('Timer transitions to break when work session completes', () async {
      // Set remaining seconds to a small value for quick testing
      timerViewModel.remainingSeconds = 1;
      timerViewModel.currentTotalDuration = 1;
      
      timerViewModel.start();
      
      await Future.delayed(const Duration(milliseconds: 2500));
      
      expect(timerViewModel.isBreak, true);
      expect(timerViewModel.remainingSeconds, equals(TimerViewModel.breakDuration));
      expect(timerViewModel.currentTotalDuration, equals(TimerViewModel.breakDuration));
      expect(timerViewModel.isRunning, false);
    });

    test('Timer transitions back to work when break completes', () async {
      // Start in break mode with small remaining time
      timerViewModel.isBreak = true;
      timerViewModel.remainingSeconds = 1;
      timerViewModel.currentTotalDuration = TimerViewModel.breakDuration;
      
      timerViewModel.start();
      
      await Future.delayed(const Duration(milliseconds: 2500));
      
      expect(timerViewModel.isBreak, false);
      expect(timerViewModel.remainingSeconds, equals(TimerViewModel.workDuration));
      expect(timerViewModel.currentTotalDuration, equals(TimerViewModel.workDuration));
      expect(timerViewModel.isRunning, false);
    });

    test('Reset resets timer to initial state', () {
      timerViewModel.remainingSeconds = 500;
      timerViewModel.isBreak = true;
      timerViewModel.isRunning = true;

      timerViewModel.reset();

      expect(timerViewModel.remainingSeconds, equals(25 * 60));
      expect(timerViewModel.isBreak, false);
      expect(timerViewModel.isRunning, false);
      expect(timerViewModel.currentTotalDuration, equals(25 * 60));
    });

    test('Reset stops a running timer', () async {
      timerViewModel.start();
      expect(timerViewModel.isRunning, true);
      
      await Future.delayed(const Duration(seconds: 1));
      
      timerViewModel.reset();
      
      expect(timerViewModel.isRunning, false);
      expect(timerViewModel.remainingSeconds, equals(TimerViewModel.workDuration));
      
      final secondsAfterReset = timerViewModel.remainingSeconds;
      await Future.delayed(const Duration(seconds: 1));
      
      expect(timerViewModel.remainingSeconds, equals(secondsAfterReset));
    });

    test('Work and break durations are correct', () {
      expect(TimerViewModel.workDuration, equals(25 * 60)); // 1500 seconds
      expect(TimerViewModel.breakDuration, equals(5 * 60)); // 300 seconds
    });

    test('Progress percentage is 1.0 when duration is 0', () {
      timerViewModel.currentTotalDuration = 0;
      timerViewModel.remainingSeconds = 0;

      expect(timerViewModel.progressPercentage, equals(1.0));
    });

    test('Progress percentage updates during countdown', () async {
      timerViewModel.remainingSeconds = 10;
      timerViewModel.currentTotalDuration = 10;
      
      final initialProgress = timerViewModel.progressPercentage;
      expect(initialProgress, equals(0.0));
      
      timerViewModel.start();
      
      await Future.delayed(const Duration(seconds: 2));
      
      timerViewModel.stop();
      
      expect(timerViewModel.progressPercentage, greaterThan(initialProgress));
      expect(timerViewModel.progressPercentage, lessThanOrEqualTo(1.0));
    });

    test('Multiple resets work correctly', () {
      timerViewModel.remainingSeconds = 200;
      timerViewModel.reset();
      expect(timerViewModel.remainingSeconds, equals(25 * 60));

      timerViewModel.remainingSeconds = 100;
      timerViewModel.reset();
      expect(timerViewModel.remainingSeconds, equals(25 * 60));
    });

    test('Formatted time pads with zeros correctly', () {
      timerViewModel.remainingSeconds = 65; // 1 minute 5 seconds
      expect(timerViewModel.formatted, equals('01:05'));

      timerViewModel.remainingSeconds = 605; // 10 minutes 5 seconds
      expect(timerViewModel.formatted, equals('10:05'));

      timerViewModel.remainingSeconds = 5999; // 99 minutes 59 seconds
      expect(timerViewModel.formatted, equals('99:59'));
    });

    test('Timer can be paused and resumed', () async {
      timerViewModel.start();
      
      await Future.delayed(const Duration(seconds: 1));
      
      timerViewModel.stop();
      final pausedSeconds = timerViewModel.remainingSeconds;
      
      await Future.delayed(const Duration(seconds: 1));
      
      expect(timerViewModel.remainingSeconds, equals(pausedSeconds));
      
      timerViewModel.start();
      
      await Future.delayed(const Duration(seconds: 1));
      
      timerViewModel.stop();
      
      expect(timerViewModel.remainingSeconds, lessThan(pausedSeconds));
    });

    test('notifyListeners is called appropriately', () {
      var listenerCallCount = 0;
      
      timerViewModel.addListener(() {
        listenerCallCount++;
      });
      
      timerViewModel.start();
      expect(listenerCallCount, greaterThan(0));
      
      final countAfterStart = listenerCallCount;
      
      timerViewModel.stop();
      expect(listenerCallCount, greaterThan(countAfterStart));
      
      final countAfterStop = listenerCallCount;
      
      timerViewModel.reset();
      expect(listenerCallCount, greaterThan(countAfterStop));
    });
  });
}
