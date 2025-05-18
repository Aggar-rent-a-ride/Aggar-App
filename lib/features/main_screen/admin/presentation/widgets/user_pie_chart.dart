import 'package:aggar/features/main_screen/admin/presentation/widgets/show_user_sections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserPieChart extends StatefulWidget {
  const UserPieChart({super.key});

  static void updateIndex(int index) {
    if (_state != null) {
      // ignore: invalid_use_of_protected_member
      _state!.setState(() {
        _state!.touchedIndex = index;
      });
    }
  }

  @override
  State<UserPieChart> createState() => _UserPieChartState();

  static _UserPieChartState? _state;
}

class _UserPieChartState extends State<UserPieChart> {
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    UserPieChart._state = this;
  }

  @override
  void dispose() {
    UserPieChart._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(touchedIndex),
        ),
      ),
    );
  }
}
