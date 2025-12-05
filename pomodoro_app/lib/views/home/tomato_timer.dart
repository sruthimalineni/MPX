import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/timer_viewmodel.dart';
import '../widgets/timer_painter.dart'; 

class TomatoTimer extends StatelessWidget {
  const TomatoTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerViewModel>(context);

    final Color activeColor = timer.isBreak ? const Color(0xff6BCB77) : const Color(0xffFF6B6B);
    final Color bgColor = activeColor.withOpacity(0.2);

    return Column(
      mainAxisSize: MainAxisSize.min, // Ensure column only takes needed space
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: activeColor, width: 2),
          ),
          child: Text(
            timer.isBreak ? "Break Time" : "Work Time",
            textAlign: TextAlign.center,
            // Allow font scaling here, layout will adjust due to Column
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: activeColor),
          ),
        ),
        
        const SizedBox(height: 30),
        
        Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: timer.progressPercentage),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.linear, 
              builder: (context, value, child) {
                return CustomPaint(
                  size: const Size(220, 220), 
                  painter: TimerPainter(
                    percentage: value,
                    taskColor: activeColor,
                    backgroundColor: bgColor,
                  ),
                );
              },
            ),
            
            // SCALING FIX: Constrain text to the circle size and use FittedBox
            SizedBox(
              width: 180, // Slightly smaller than 220 to allow padding
              height: 180,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain, // Scale text down to fit if needed
                  child: Text(
                    timer.formatted,
                    style: TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.w900, 
                      color: activeColor
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}