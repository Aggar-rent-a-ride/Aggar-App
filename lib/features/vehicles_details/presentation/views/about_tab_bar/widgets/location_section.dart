import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(30),
        //TODO: style here will be change
        Text(
          "Location",
          style: TextStyle(
            color: AppColors.myGray100_3,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(10),
        Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on_sharp,
                  size: 24,
                  color: AppColors.myGray100_2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    "Minya al-Qamh, Sharkia, Egypt",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.myGray100_2,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Row(
                children: [
                  Text(
                    "Distance",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.myGray100_2,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    "1.4 km",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.myBlue100_2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image(
            image: const AssetImage(AppAssets.assetsImagesMap),
            fit: BoxFit.cover,
            height: MediaQuery.sizeOf(context).width * 0.42,
            width: MediaQuery.sizeOf(context).width,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              "show location on google maps",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.myBlue100_2,
              ),
            ),
          ),
        )
      ],
    );
  }
}
