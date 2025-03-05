import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_list_view.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_main_image_button_content.dart';
import 'package:flutter/material.dart';

class VehicleImagesSection extends StatelessWidget {
  const VehicleImagesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Images :",
          style: AppStyles.bold22(context).copyWith(
            color: AppColors.myBlue100_2,
          ),
        ),
        const PickMainImageButtonContent(),
        Text(
          "additional images",
          style: AppStyles.medium18(context).copyWith(
            color: AppColors.myBlue100_1,
          ),
        ),
        const AdditionalImageListView(),
      ],
    );
  }
}
