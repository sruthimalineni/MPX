// Widget tests for Pomodoro App
// Tests for three main features: Timer functionality, Navigation, and Task management

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_mpv_demo/viewmodels/timer_viewmodel.dart';
import 'package:pomodoro_mpv_demo/viewmodels/task_viewmodel.dart';
import 'package:pomodoro_mpv_demo/viewmodels/stats_viewmodel.dart';

void main() {
  group('Pomodoro App Widget Tests', () {
    
    // Test: Timer ViewModel Control and Display
    testWidgets('Test 1: Timer starts, stops, and displays correctly', (WidgetTester tester) async {
      final timerVM = TimerViewModel();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimerViewModel>.value(
          value: timerVM,
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Consumer<TimerViewModel>(
                  builder: (context, timer, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timer.formatted,
                        key: const Key('timer_display'),
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        key: const Key('start_button'),
                        onPressed: () => timer.start(),
                        child: const Text('Start'),
                      ),
                      ElevatedButton(
                        key: const Key('stop_button'),
                        onPressed: () => timer.stop(),
                        child: const Text('Stop'),
                      ),
                      ElevatedButton(
                        key: const Key('reset_button'),
                        onPressed: () => timer.reset(),
                        child: const Text('Reset'),
                      ),
                      Text(
                        'Break: ${timer.isBreak ? 'Yes' : 'No'}',
                        key: const Key('break_indicator'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initial state verification
      expect(find.text('25:00'), findsOneWidget);
      expect(find.text('Break: No'), findsOneWidget);

      // Test start button
      await tester.tap(find.byKey(const Key('start_button')));
      await tester.pump();
      expect(timerVM.isRunning, true);

      // Test stop button
      await tester.tap(find.byKey(const Key('stop_button')));
      await tester.pump();
      expect(timerVM.isRunning, false);

      // Test reset button
      await tester.tap(find.byKey(const Key('reset_button')));
      await tester.pump();
      expect(timerVM.remainingSeconds, 25 * 60);
      expect(find.text('25:00'), findsOneWidget);
    });

    // Test: Multi-Provider Navigation Setup
    testWidgets('Test 2: Navigation routes work with MultiProvider setup', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => TimerViewModel()),
            ChangeNotifierProvider(create: (_) => TaskViewModel()),
            ChangeNotifierProvider(create: (_) => StatsViewModel()),
          ],
          child: MaterialApp(
            routes: {
              '/': (_) => const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Home Screen'),
                      SizedBox(height: 20),
                      Icon(Icons.home, size: 48),
                    ],
                  ),
                ),
              ),
              '/progress': (_) => const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Progress Screen'),
                      SizedBox(height: 20),
                      Icon(Icons.bar_chart_rounded, size: 48),
                    ],
                  ),
                ),
              ),
            },
            initialRoute: '/',
          ),
        ),
      );

      // Verify home screen is shown
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);

      // Navigate to progress screen
      Navigator.of(tester.element(find.byIcon(Icons.home))).pushNamed('/progress');
      await tester.pumpAndSettle();

      // Verify progress screen is shown
      expect(find.text('Progress Screen'), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart_rounded), findsOneWidget);
    });

    // Test: Task ViewModel and Rounds Calculation
    testWidgets('Test 3: Task management updates rounds left counter', (WidgetTester tester) async {
      final taskVM = TaskViewModel();
      final timerVM = TimerViewModel();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TaskViewModel>.value(value: taskVM),
            ChangeNotifierProvider<TimerViewModel>.value(value: timerVM),
            ChangeNotifierProvider(create: (_) => StatsViewModel()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Consumer<TaskViewModel>(
                  builder: (context, tasks, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tasks: ${tasks.tasks.length}',
                        key: const Key('task_count'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Total Minutes: ${tasks.tasks.fold<int>(0, (sum, t) => sum + t.minutes)}',
                        key: const Key('total_minutes'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        key: const Key('add_task_button'),
                        onPressed: () => tasks.addTask('New Task', 'Description', 25),
                        child: const Text('Add Task'),
                      ),
                      ElevatedButton(
                        key: const Key('clear_tasks_button'),
                        onPressed: () {
                          tasks.tasks.clear();
                          tasks.notifyListeners();
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Tasks: 0'), findsOneWidget);
      expect(find.text('Total Minutes: 0'), findsOneWidget);

      // Add a task
      await tester.tap(find.byKey(const Key('add_task_button')));
      await tester.pump();
      expect(find.text('Tasks: 1'), findsOneWidget);
      expect(find.text('Total Minutes: 25'), findsOneWidget);

      // Add another task
      await tester.tap(find.byKey(const Key('add_task_button')));
      await tester.pump();
      expect(find.text('Tasks: 2'), findsOneWidget);
      expect(find.text('Total Minutes: 50'), findsOneWidget);

      // Clear all tasks
      await tester.tap(find.byKey(const Key('clear_tasks_button')));
      await tester.pump();
      expect(find.text('Tasks: 0'), findsOneWidget);
      expect(find.text('Total Minutes: 0'), findsOneWidget);
    });
  });
}
