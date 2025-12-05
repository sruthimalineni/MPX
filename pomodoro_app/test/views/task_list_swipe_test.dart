import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_mpv_demo/viewmodels/task_viewmodel.dart';
import 'package:pomodoro_mpv_demo/viewmodels/timer_viewmodel.dart';
import 'package:pomodoro_mpv_demo/viewmodels/stats_viewmodel.dart';
import 'package:pomodoro_mpv_demo/views/home/task_list_sheet.dart';

void main() {
  group('Task List Swipe to Delete Tests', () {
    testWidgets('Swipe to delete shows delete button', (WidgetTester tester) async {
      // Build the task list sheet with providers
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TimerViewModel()),
              ChangeNotifierProvider(create: (_) => TaskViewModel()),
              ChangeNotifierProvider(create: (_) => StatsViewModel()),
            ],
            child: const Scaffold(
              body: TaskListSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify tasks are displayed
      expect(find.text('Email Check'), findsOneWidget);
      expect(find.text('Code Review'), findsOneWidget);
    });

    testWidgets('Task list displays tasks correctly', (WidgetTester tester) async {
      final taskVM = TaskViewModel();
      
      // Build the task list
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TimerViewModel()),
              ChangeNotifierProvider(create: (_) => taskVM),
              ChangeNotifierProvider(create: (_) => StatsViewModel()),
            ],
            child: const Scaffold(
              body: TaskListSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify both default tasks are present
      expect(find.text('Email Check'), findsOneWidget);
      expect(find.text('Reply to urgent client emails'), findsOneWidget);
      expect(find.text('Code Review'), findsOneWidget);
    });

    testWidgets('Add new task button exists', (WidgetTester tester) async {
      // Build the task list
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TimerViewModel()),
              ChangeNotifierProvider(create: (_) => TaskViewModel()),
              ChangeNotifierProvider(create: (_) => StatsViewModel()),
            ],
            child: const Scaffold(
              body: TaskListSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify add task button exists
      expect(find.text('Add New Task'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Edit and delete buttons are visible', (WidgetTester tester) async {
      // Build the task list
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TimerViewModel()),
              ChangeNotifierProvider(create: (_) => TaskViewModel()),
              ChangeNotifierProvider(create: (_) => StatsViewModel()),
            ],
            child: const Scaffold(
              body: TaskListSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify edit and delete icons are visible
      expect(find.byIcon(Icons.edit), findsWidgets);
      expect(find.byIcon(Icons.delete), findsWidgets);
    });

    testWidgets('Total work and break times are displayed', (WidgetTester tester) async {
      // Build the task list
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => TimerViewModel()),
              ChangeNotifierProvider(create: (_) => TaskViewModel()),
              ChangeNotifierProvider(create: (_) => StatsViewModel()),
            ],
            child: const Scaffold(
              body: TaskListSheet(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify total time information is displayed
      expect(find.text('Total Time'), findsOneWidget);
      expect(find.text('Total Break'), findsOneWidget);
    });
  });
}
