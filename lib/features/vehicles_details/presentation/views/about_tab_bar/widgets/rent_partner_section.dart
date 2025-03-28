import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_icon_button.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/owner_image_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/owner_name_section.dart';
import 'package:flutter/material.dart';

class RentPartnerSection extends StatelessWidget {
  const RentPartnerSection({
    super.key,
    this.pfpImage,
    required this.renterName,
  });
  final String? pfpImage;
  final String renterName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rent Partner",
            style: AppStyles.bold18(context).copyWith(
              color: AppLightColors.myGray100_3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                OwnerImageSection(
                  pfpImage: pfpImage,
                ),
                OwnerNameSection(
                  renterName: renterName,
                ),
                const Spacer(),
                const CustomIconButton(
                  imageIcon: AppAssets.assetsIconsChat,
                  flag: false,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
