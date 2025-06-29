import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/widgets/edit_profile_with_settings_buttons.dart';
import 'package:aggar/features/profile/presentation/widgets/name_with_user_name.dart';
import 'package:aggar/features/profile/presentation/widgets/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import '../../../../../new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import '../../../../../new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import '../../../../../new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import '../../../../../new_vehicle/presentation/views/add_vehicle_screen.dart';
import '../widgets/profile_tab_bar.dart';

class RenterProfileScreen extends StatelessWidget {
  const RenterProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "Dddd",
        onPressed: () {
          context.read<AddVehicleCubit>().reset();
          context.read<MainImageCubit>().reset();
          context.read<AdditionalImageCubit>().reset();
          context.read<MapLocationCubit>().reset();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVehicleScreen(),
            ),
          );
        },
        backgroundColor: context.theme.blue100_1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.add,
          color: context.theme.white100_1,
          size: 30,
        ),
      ),
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
