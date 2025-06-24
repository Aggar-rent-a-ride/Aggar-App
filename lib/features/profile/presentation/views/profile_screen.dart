import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:aggar/features/profile/presentation/widgets/edit_profile_with_settings_buttons.dart';
import 'package:aggar/features/profile/presentation/widgets/name_with_user_name.dart';
import 'package:aggar/features/profile/presentation/widgets/profile_tab_bar_section.dart';
import 'package:aggar/features/profile/presentation/widgets/user_photo.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/cubit/refresh token/token_refresh_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    refreshProfile();
    super.initState();
  }

  Future<void> refreshProfile() async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.getAccessToken();
    if (token != null) {
      context.read<ProfileCubit>().fetchFavoriteVehicles(token);
      context.read<ReviewCubit>().getUserReviews("22", token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 0),
                      ),
                    ],
                    color: context.theme.blue100_1,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Profile Account",
                      style: AppStyles.bold20(context).copyWith(
                        color: context.theme.white100_1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const UserPhoto(),
              ],
            ),
            const Gap(50),
            const NameWithUserName(),
            const EditProfileWithSettingsButtons(),
            const ProfileTabBarSection(),
          ],
        ),
      ),
    );
  }
}
