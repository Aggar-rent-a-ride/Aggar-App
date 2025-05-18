import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/show_user_sections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPieChart extends StatefulWidget {
  const UserPieChart({super.key, required this.accessToken});

  final String accessToken;

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
    // Fetch user totals when the widget is initialized
    context.read<UserCubit>().fetchUserTotals(widget.accessToken);
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
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserTotalsLoaded) {
            return PieChart(
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
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: showingSections(
                  state.totalReportsByType,
                  touchedIndex,
                ),
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
