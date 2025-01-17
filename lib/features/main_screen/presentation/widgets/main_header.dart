import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                CustomIcon(
                  hight: 25,
                  width: 25,
                  flag: false,
                  imageIcon: AppAssets.assetsIconsLocation,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Location",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "Minya al-Qamh, Sharkia, Egypt",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.myBlue100_4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomIcon(
                      hight: 0,
                      width: 0,
                      flag: false,
                      imageIcon: AppAssets.assetsIconsNotification,
                    ),
                  ),
                ),
                Positioned(
                  right: 9,
                  top: 9,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: AppColors.myGreen100_1,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(20),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const Gap(10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.12,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.myBlue100_4,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const CustomIcon(
                    hight: 20,
                    width: 20,
                    flag: false,
                    imageIcon: AppAssets.assetsIconsSort,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
