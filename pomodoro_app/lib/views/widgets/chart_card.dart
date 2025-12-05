import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final List<double> values;
  final List<String> xLabels;
  final Color lineColor;
  final double? fixedInterval;

  const ChartCard({
    super.key,
    required this.title,
    required this.values,
    required this.xLabels,
    this.lineColor = Colors.black,
    this.fixedInterval,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Find the highest data point
    double maxDataValue = 0;
    if (values.isNotEmpty) {
      maxDataValue = values.reduce((curr, next) => curr > next ? curr : next);
    }

    // 2. Calculate maxY with extra spacing (Buffer)
    double maxY = maxDataValue;
    
    if (fixedInterval != null) {
      double interval = fixedInterval!;
      
      // A: Snap to the nearest interval (e.g., 45 -> 60, 120 -> 120)
      double snappedMax = (maxDataValue / interval).ceil() * interval;

      // B: Add 2 extra intervals of buffer (e.g., 120 becomes 180)
      // This prevents the "cut off" look and follows your 120->180 example.
      maxY = snappedMax + (interval * 2);
      
    } else {
       // Fallback percentage buffer if no interval is provided
       maxY = maxY * 1.5; 
       if (maxY == 0) maxY = 10;
    }
    
    final double interval = fixedInterval ?? _calculateInterval(maxY);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xffFFF9D6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Row(
              children: [
                // --- PART 1: THE FIXED Y-AXIS ---
                SizedBox(
                  width: 30,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: maxY,
                      minX: 0,
                      maxX: 1,
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 25,
                            interval: interval,
                            getTitlesWidget: (value, meta) {
                              // Don't show the very top label if it matches maxY exactly
                              // to avoid cutting off slightly
                              if (value > maxY) return const SizedBox.shrink();
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.right,
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [],
                    ),
                  ),
                ),

                // --- PART 2: THE SCROLLABLE DATA ---
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double widthPerDataPoint = constraints.maxWidth / 6;
                      double totalChartWidth = widthPerDataPoint * values.length;
                      if (totalChartWidth < constraints.maxWidth) {
                        totalChartWidth = constraints.maxWidth;
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Container(
                          width: totalChartWidth,
                          padding: const EdgeInsets.only(right: 16, left: 10),
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: maxY,
                              minX: 0,
                              maxX: (values.length - 1).toDouble(),
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= 0 && index < xLabels.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            xLabels[index],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                  bottom: BorderSide(color: Colors.grey, width: 1),
                                ),
                              ),
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (touchedSpot) => Colors.blueGrey,
                                  tooltipMargin: 10, // Adjusts distance from the point
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((LineBarSpot touchedSpot) {
                                      return LineTooltipItem(
                                        touchedSpot.y.toInt().toString(),
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
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
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: lineColor.withOpacity(0.1),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateInterval(double maxVal) {
    if (maxVal == 0) return 10;
    return (maxVal / 5).ceilToDouble();
  }
}