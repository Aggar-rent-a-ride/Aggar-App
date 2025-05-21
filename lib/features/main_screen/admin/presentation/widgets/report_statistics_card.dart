import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_statistics_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportStatisticsCard extends StatelessWidget {
  const ReportStatisticsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminMainCubit, AdminMainState>(
        builder: (context, state) {
      if (state is AdminMainConnected &&
          state.isStatisticsLoaded &&
          state.isReportsLoaded) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: context.theme.white100_2,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: const ReportStatisticsBody(),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
