import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_mpv_demo/services/date_api.dart'; 
import 'package:provider/provider.dart';
import '../../viewmodels/timer_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';
import 'task_list_sheet.dart';
import 'tomato_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentDate = "Loading Date...";
  int _roundsLeft = 0;
  bool _timerListenerAttached = false;
  bool _taskListenerAttached = false;
  bool _prevIsBreak = false;

  @override
  void initState() {
    super.initState();
    _fetchDate();
  }

  Future<void> _fetchDate() async {
    try {
      final date = await DateApi().fetchCurrentDate();
      if (mounted) {
        setState(() {
          _currentDate = DateFormat.yMMMd().format(date);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentDate = DateFormat.yMMMd().format(DateTime.now());
        });
      }
    }
  }

  int _computeRoundsFromTasks(TaskViewModel taskVM) {
    final totalMinutes = taskVM.tasks.fold<int>(0, (sum, t) => sum + t.minutes);
    if (totalMinutes <= 0) return 0;
    return (totalMinutes / 25).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerViewModel>(context);
    final taskVM = Provider.of<TaskViewModel>(context);

    if (!_timerListenerAttached) {
      _timerListenerAttached = true;
      timer.addListener(() {
        if (!_prevIsBreak && timer.isBreak) {
          setState(() {
            if (_roundsLeft > 0) _roundsLeft -= 1;
          });
        }
        _prevIsBreak = timer.isBreak;
      });
    }

    if (!_taskListenerAttached) {
      _taskListenerAttached = true;
      taskVM.addListener(() {
        setState(() {
          _roundsLeft = _computeRoundsFromTasks(taskVM);
        });
      });
      _roundsLeft = _computeRoundsFromTasks(taskVM);
    }

    return Scaffold(
      backgroundColor: const Color(0xffDFF8C8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Pomodoro",
                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    _currentDate,
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.bar_chart_rounded, size: 32),
                              onPressed: () => Navigator.pushNamed(context, '/progress'),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      const TomatoTimer(),
                      
                      const SizedBox(height: 30),
                      
                      if (_roundsLeft > 0) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFF9D6),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timelapse, color: Color(0xffFF6B6B)),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Rounds of Pomodoro left: $_roundsLeft',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 1. Start/Stop Button (Left Side)
                          if (!timer.isRunning)
                            ElevatedButton(
                              onPressed: timer.start,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff6BCB77),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              ),
                              child: const Text("Start", style: TextStyle(color: Colors.white, fontSize: 18)),
                            )
                          else
                            ElevatedButton(
                              onPressed: timer.stop,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFF6B6B),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              ),
                              child: const Text("Stop", style: TextStyle(color: Colors.white, fontSize: 18)),
                            ),

                          const SizedBox(width: 20), 

                          
                          ElevatedButton(
                            onPressed: timer.reset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffFFF9D6),
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(16),
                              elevation: 4,
                            ),
                            child: const Icon(Icons.refresh, color: Colors.black, size: 28),
                          ),
                        ],
                      ),
                      
                      const Spacer(),

                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const TaskListSheet(),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 30, bottom: 40),
                          decoration: const BoxDecoration(
                            color: Color(0xffFFF9D6),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                          ),
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 300),
                              width: 200,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xffFF6B6B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Task List",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}