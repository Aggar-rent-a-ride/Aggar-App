import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_icon_button.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/owner_image_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/owner_name_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutTabBarView extends StatelessWidget {
  const AboutTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(30),
            Text(
              "Rent Partner",
              style: TextStyle(
                color: AppColors.myGray100_3,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  OwnerImageSection(),
                  OwnerNameSection(),
                  Spacer(),
                  CustomIconButton(
                    imageIcon: AppAssets.assetsIconsChat,
                    flag: false,
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
