import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/profile/presentation/widgets/edit_profile_with_settings_buttons.dart';
import 'package:aggar/features/profile/presentation/widgets/name_with_user_name.dart';
import 'package:aggar/features/profile/presentation/widgets/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/cubit/user_cubit/user_info_cubit.dart';
import '../../../../../../core/cubit/user_review_cubit/user_review_cubit.dart';
import '../../../customer/presentation/cubit/profile/profile_cubit.dart';
import '../widgets/profile_tab_bar.dart';

class RenterProfileScreen extends StatefulWidget {
  const RenterProfileScreen({super.key});

  @override
  State<RenterProfileScreen> createState() => _RenterProfileScreenState();
}

class _RenterProfileScreenState extends State<RenterProfileScreen> {
  @override
  void initState() {
    refreshProfile();
    super.initState();
  }

  Future<void> refreshProfile() async {
    String? userId = await context.read<LoginCubit>().getUserId();
    if (userId != null) {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final token = await tokenCubit.ensureValidToken();
      if (token != null) {
        context.read<UserInfoCubit>().fetchUserInfo(userId, token);
        context.read<ProfileCubit>().fetchRenterVehicles(token);
        context.read<UserReviewCubit>().getUserReviews(userId, token);
      }
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
            const EditProfileWithSettingsButtons(
              isRenter: true,
            ),
            const Gap(15),
            const RenterProfileTabBarSection()
          ],
        ),
      ),
    );
  }
}
