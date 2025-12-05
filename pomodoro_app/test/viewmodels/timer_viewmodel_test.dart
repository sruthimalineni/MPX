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
      // Test formatted getter
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

      // Half way through
      timerViewModel.remainingSeconds = 750;
      expect(timerViewModel.progressPercentage, equals(0.5));

      // Completed
      timerViewModel.remainingSeconds = 0;
      expect(timerViewModel.progressPercentage, equals(1.0));
    });

    test('Reset resets timer to initial state', () {
      // Modify state
      timerViewModel.remainingSeconds = 500;
      timerViewModel.isBreak = true;
      timerViewModel.isRunning = true;

      // Reset
      timerViewModel.reset();

      // Verify reset state
      expect(timerViewModel.remainingSeconds, equals(25 * 60));
      expect(timerViewModel.isBreak, false);
      expect(timerViewModel.isRunning, false);
      expect(timerViewModel.currentTotalDuration, equals(25 * 60));
    });

    test('Stop stops the timer', () {
      timerViewModel.isRunning = true;
      timerViewModel.remainingSeconds = 1000;

      timerViewModel.stop();

      expect(timerViewModel.isRunning, false);
    });

    test('Work and break durations are correct', () {
      // Verify constants
      expect(TimerViewModel.workDuration, equals(25 * 60)); // 1500 seconds
      expect(TimerViewModel.breakDuration, equals(5 * 60)); // 300 seconds
    });

    test('Progress percentage is 1.0 when duration is 0', () {
      timerViewModel.currentTotalDuration = 0;
      timerViewModel.remainingSeconds = 0;

      expect(timerViewModel.progressPercentage, equals(1.0));
    });

    test('Multiple resets work correctly', () {
      // First reset
      timerViewModel.remainingSeconds = 200;
      timerViewModel.reset();
      expect(timerViewModel.remainingSeconds, equals(25 * 60));

      // Second reset
      timerViewModel.remainingSeconds = 100;
      timerViewModel.reset();
      expect(timerViewModel.remainingSeconds, equals(25 * 60));
    });

    test('Formatted time pads with zeros correctly', () {
      // Single digit minutes and seconds
      timerViewModel.remainingSeconds = 65; // 1 minute 5 seconds
      expect(timerViewModel.formatted, equals('01:05'));

      // Double digit values should not add extra padding
      timerViewModel.remainingSeconds = 605; // 10 minutes 5 seconds
      expect(timerViewModel.formatted, equals('10:05'));

      // Large values
      timerViewModel.remainingSeconds = 5999; // 99 minutes 59 seconds
      expect(timerViewModel.formatted, equals('99:59'));
    });
  });
}
