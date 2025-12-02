import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/timer_viewmodel.dart';

class TomatoTimer extends StatelessWidget {
  const TomatoTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<TimerViewModel>(context);

    return Column(
      children: [
        Image.asset("assets/tomato.png", height: 200),
        const SizedBox(height: 15),
        Text(
          timer.formatted,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
