import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:aggar/features/settings/presentation/widgets/profile_details_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoLoading) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.white100_1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.theme.grey100_1,
                width: 1,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is UserInfoError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.white100_1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.theme.grey100_1,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'Error loading profile',
                style: AppStyles.regular14(context).copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (state is UserInfoSuccess) {
          final user = state.userInfoModel;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.white100_1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.theme.grey100_1,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: context.theme.blue100_1,
                      backgroundImage: user.imageUrl != null
                          ? NetworkImage(user.imageUrl!)
                          : null,
                      child: user.imageUrl == null
                          ? Icon(
                              Icons.person,
                              size: 30,
                              color: context.theme.white100_1,
                            )
                          : null,
                    ),
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: AppStyles.semiBold18(context).copyWith(
                              color: context.theme.black100,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            user.userName,
                            style: AppStyles.regular14(context).copyWith(
                              color: context.theme.grey100_1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              userId: user.id.toString(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        color: context.theme.blue100_1,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                const Gap(10),
                if (user.address != null)
                  ProfileDetailsRow(
                    label: "Address",
                    value: user.address!,
                    icon: Icons.location_on_outlined,
                  ),
                if (user.address != null) const Gap(12),
                const Gap(10),
                ProfileDetailsRow(
                  label: "Date of Birth",
                  value: getFormattedDate(DateTime.parse(user.dateOfBirth)),
                  icon: Icons.calendar_today_outlined,
                ),
                const Gap(12),
                if (user.bio != null)
                  ProfileDetailsRow(
                    label: "Bio",
                    value: user.bio!,
                    icon: Icons.info_outline,
                  ),
                if (user.bio != null) const Gap(12),
                ProfileDetailsRow(
                  label: "Role",
                  value: user.role,
                  icon: Icons.badge_outlined,
                ),
              ],
            ),
          );
        }

        // Default empty state
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.theme.grey100_1,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              'No profile data available',
              style: AppStyles.regular14(context).copyWith(
                color: context.theme.grey100_1,
              ),
            ),
          ),
        );
      },
    );
  }
}
