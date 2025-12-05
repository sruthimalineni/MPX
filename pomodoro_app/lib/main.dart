import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'services/firebase_options.dart'; 
import 'app.dart';
import 'viewmodels/timer_viewmodel.dart';
import 'viewmodels/task_viewmodel.dart';
import 'viewmodels/stats_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  //Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => StatsViewModel()),
      ],
      child: const PomodoroApp(),
    ),
  );
}