import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'views/home/home_screen.dart';
import 'views/progress/progress_screen.dart';

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routes: {
        '/': (_) => const HomeScreen(),
        '/progress': (_) => const ProgressScreen(),
      },
    );
  }
}
