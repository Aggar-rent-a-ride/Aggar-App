import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/custom_gallary_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GallarySection extends StatelessWidget {
  const GallarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(30),
        //TODO: the font not handle yet
        Text(
          "Gallary",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.myGray100_3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(5),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).width * 0.21,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => const CustomGallaryImage(),
            itemCount: 6,
          ),
        )
      ],
    );
  }
}
