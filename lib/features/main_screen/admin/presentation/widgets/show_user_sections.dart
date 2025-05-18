import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> showingSections(
    Map<String, int> totalUsersByRole, int touchedIndex) {
  final colors = [
    const Color(0xFF3A3F9B), // Admin
    const Color(0xFF8E90E8), // Renter
    const Color(0xFFC6C7F4), // Customer
  ];

  final userTypes = ["Admin", "Renter", "Customer"];
  final total = totalUsersByRole.values.fold(0, (sum, value) => sum + value);

  if (total == 0) {
    // Handle case with no data
    return [
      PieChartSectionData(
        color: Colors.grey,
        value: 1,
        title: 'No Data',
        radius: 35.0,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      ),
    ];
  }

  return List.generate(userTypes.length, (i) {
    final isTouched = i == touchedIndex;
    final fontSize = isTouched ? 16.0 : 12.0;
    final radius = isTouched ? 40.0 : 35.0;
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    final value = totalUsersByRole[userTypes[i]]?.toDouble() ?? 0.0;
    final percentage = ((value / total) * 100).toStringAsFixed(1);

    return PieChartSectionData(
      color: colors[i],
      value: value,
      title: '$percentage%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: shadows,
      ),
    );
  });
}
