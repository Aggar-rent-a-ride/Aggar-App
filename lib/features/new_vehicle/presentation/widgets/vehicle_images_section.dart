import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/about_vehicle_section.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_main_image_button_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleImagesSection extends StatelessWidget {
  const VehicleImagesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int len = 100;
    return Column(
      children: [
        const AboutVehicleSection(),
        const Gap(25),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicle Images :",
              style: AppStyles.bold22(context).copyWith(
                color: AppColors.myBlue100_2,
              ),
            ),
            const Gap(10),
            const PickMainImageButtonContent(),
            const Gap(10),
            Text(
              "additional images",
              style: AppStyles.medium18(context).copyWith(
                color: AppColors.myBlue100_1,
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 90,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: len,
                itemBuilder: (context, index) => Row(
                  children: [
                    const AdditionalImageButton(),
                    index == len - 1
                        ? Container(
                            height: 50,
                            width: 50,
                            color: Colors.amberAccent,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
