import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/widgets/edit_profile_with_settings_buttons.dart';
import 'package:aggar/features/profile/presentation/widgets/name_with_user_name.dart';
import 'package:aggar/features/profile/presentation/widgets/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../widgets/profile_tab_bar.dart';

class RenterProfileScreen extends StatelessWidget {
  const RenterProfileScreen({super.key});

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
            const Gap(15),
            const RenterProfileTabBarSection()
          ],
        ),
      ),
    );
  }
}
