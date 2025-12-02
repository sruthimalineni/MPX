import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/stats_viewmodel.dart';
import '../widgets/chart_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsViewModel>().weeklyStats;

    return Scaffold(
      backgroundColor: const Color(0xffDFF8C8), // Light Green
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Progress",
          style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ChartCard(
              title: "Time Spent",
              values: stats.map((e) => e.minutes.toDouble()).toList(),
              lineColor: const Color(0xffE91E63), // Pink
            ),
            const SizedBox(height: 20),
            
            ChartCard(
              title: "Tasks Completed",
              values: stats.map((e) => e.tasksCompleted.toDouble()).toList(),
              lineColor: const Color(0xff2196F3), // Blue
            ),
          ],
        ),
      ),
    );
  }
}