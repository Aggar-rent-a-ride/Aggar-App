import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

BarChartGroupData createBarGroup(
    int x, double y, Color color, bool isSelected) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        width: isSelected ? 12 : 10,
        borderRadius: BorderRadius.circular(8),
        borderSide: isSelected
            ? const BorderSide(color: Colors.black, width: 1)
            : BorderSide.none,
      ),
    ],
  );
}
