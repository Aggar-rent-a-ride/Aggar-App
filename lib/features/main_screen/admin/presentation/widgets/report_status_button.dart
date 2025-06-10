import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/report_cubit/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportStatusButton extends StatefulWidget {
  const ReportStatusButton({
    super.key,
    required this.status,
    required this.reportIds,
  });

  final String status;
  final List<int> reportIds;

  @override
  State<ReportStatusButton> createState() => _ReportStatusButtonState();
}

class _ReportStatusButtonState extends State<ReportStatusButton> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.white100_1,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: DropdownButton<String>(
              value: _selectedStatus,
              items: <String>['Pending', 'Reviewed', 'Rejected']
                  .map<DropdownMenuItem<String>>((String value) {
                Color color;
                switch (value) {
                  case 'Reviewed':
                    color = AppConstants.myGreen100_1;
                    break;
                  case 'Rejected':
                    color = AppConstants.myRed100_1;
                    break;
                  default:
                    color = AppConstants.myYellow100_1;
                }
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) async {
                if (newValue != null && newValue != _selectedStatus) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                  final tokenCubit = context.read<TokenRefreshCubit>();
                  final token = await tokenCubit.getAccessToken();
                  if (token != null) {
                    final reportCubit = context.read<ReportCubit>();
                    await reportCubit.updateReportStatus(
                      token,
                      newValue,
                      widget.reportIds,
                    );
                    await reportCubit.refreshReports(
                      token,
                      null,
                      null,
                      null,
                      null,
                    );
                  }
                }
              },
              underline: const SizedBox(),
              isExpanded: true,
              style: AppStyles.regular14(context).copyWith(
                color: context.theme.black100,
              ),
              dropdownColor: context.theme.white100_1,
              iconEnabledColor: context.theme.blue100_8,
            ),
          ),
        ),
      ),
    );
  }
}
