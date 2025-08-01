import 'package:aggar/core/cubit/reportId/report_by_id_cubit.dart';
import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/app_user_target_type.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/customer_review_target_type.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/message_target_type.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/renter_review_target_type.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_status_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/report_type_with_status.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/reporter_with_created_at_section.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/vehicle_target_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ReportDetailsBody extends StatelessWidget {
  const ReportDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportByIdCubit, ReportByIdState>(
      builder: (context, state) {
        if (state is ReportByIdLoaded) {
          String formattedDate = 'Unknown';
          try {
            final dateTime = DateTime.parse(state.report.createdAt);
            formattedDate = DateFormat('MMM d, yyyy, h:mm a').format(dateTime);
          } catch (e) {
            formattedDate = state.report.createdAt;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReportTypewithStatus(
                    targetType: state.report.targetType,
                  ),
                  const Gap(8),
                  state.report.description != ""
                      ? Text(
                          state.report.description,
                          style: AppStyles.regular16(context).copyWith(
                            color: context.theme.black100,
                          ),
                        )
                      : const SizedBox(),
                  const Gap(10),
                  state.report.targetType == "Vehicle"
                      ? VehicleTargetType(state: state)
                      : state.report.targetType == "AppUser"
                          ? AppUserTargetType(state: state)
                          : state.report.targetType == "Message"
                              ? MessageTargetType(state: state)
                              : state.report.targetType == "CustomerReview"
                                  ? CustomerReviewTargetType(state: state)
                                  : state.report.targetType == "RenterReview"
                                      ? RenterReviewTargetType(state: state)
                                      : const SizedBox(),
                  const Gap(16),
                  ReporterWithCreatedAtSection(
                    formattedDate: formattedDate,
                    state: state,
                  ),
                  const Gap(25),
                  ReportStatusButton(
                    reportIds: [state.report.id],
                    status: state.report.status,
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: context.theme.black50,
                ),
                const Gap(12),
                const Text(
                  "Failed to load report details.",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
