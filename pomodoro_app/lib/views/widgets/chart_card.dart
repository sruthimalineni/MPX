import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final List<double> values;
  final Color lineColor;

  const ChartCard({
    super.key,
    required this.title,
    required this.values,
    this.lineColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffFFF9D6), 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xffFF6B6B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 20),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Dummy mapping for Week days or Months based on index
                        const titles = ['OCT', 'NOV', 'DEC', 'JAN', 'FEB', 'MAR', 'APR'];
                        if (value.toInt() >= 0 && value.toInt() < titles.length) {
                           return Padding(
                             padding: const EdgeInsets.only(top: 8.0),
                             child: Text(titles[value.toInt()], style: const TextStyle(fontSize: 10)),
                           );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.grey, width: 1),
                    left: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (int i = 0; i < values.length; i++)
                        FlSpot(i.toDouble(), values[i]),
                    ],
                    isCurved: false,
                    color: lineColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}