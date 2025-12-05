import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/stats_viewmodel.dart';
import '../widgets/chart_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final List<String> _monthLabels = const [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<StatsViewModel>(context, listen: false).fetchStats()
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsVM = context.watch<StatsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffDFF8C8),
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
              title: "Time Spent (Mins)",
              values: statsVM.monthlyTimeValues,
              xLabels: _monthLabels,
              lineColor: const Color(0xffE91E63),
              fixedInterval: 30, // <--- SET 30 MIN INTERVAL
            ),
            const SizedBox(height: 20),
            
            ChartCard(
              title: "Tasks Completed",
              values: statsVM.monthlyTaskValues,
              xLabels: _monthLabels,
              lineColor: const Color(0xff2196F3),
              fixedInterval: 2, // <--- SET 2 TASK INTERVAL
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}