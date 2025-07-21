import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/features/settings/presentation/widgets/profile_details_row.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PersonalInformationSection extends StatelessWidget {
  const PersonalInformationSection({super.key, required this.state});

  final UserInfoSuccess state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 0)),
        ],
      ),
      child: Column(
        children: [
          if (state.userInfoModel.address != null)
            ProfileDetailsRow(
              label: "Address",
              value: state.userInfoModel.address!,
              icon: Icons.location_on_outlined,
              color: context.theme.blue100_1,
            ),
          if (state.userInfoModel.address != null) const Gap(12),
          const Gap(10),
          ProfileDetailsRow(
            color: context.theme.blue100_1,
            label: "Date of Birth",
            value: getFormattedDate(
              DateTime.parse(state.userInfoModel.dateOfBirth),
            ),
            icon: Icons.calendar_today_outlined,
          ),
          const Gap(12),
          if (state.userInfoModel.bio != null)
            ProfileDetailsRow(
              color: context.theme.blue100_1,
              label: "Bio",
              value: state.userInfoModel.bio!,
              icon: Icons.info_outline,
            ),
          if (state.userInfoModel.bio != null) const Gap(12),
          ProfileDetailsRow(
            color: context.theme.blue100_1,
            label: "Role",
            value: state.userInfoModel.role,
            icon: Icons.badge_outlined,
          ),
          const Gap(20),
        ],
      ),
    );
  }
}
