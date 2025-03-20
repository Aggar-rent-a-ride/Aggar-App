import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_screen_location_icon_and_location_text.dart';
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Location",
                  style: AppStyles.regular14(context)
                      .copyWith(color: AppLightColors.myWhite50_1),
                ),
                const Gap(5),
                const MainScreenLocationIconAndLocationText(),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppLightColors.myBlue100_4,
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
                      color: AppLightColors.myGreen100_1,
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
            const Expanded(
              child: MainScreenSearchField(),
            ),
            const Gap(10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.12,
              child: Container(
                decoration: BoxDecoration(
                  color: AppLightColors.myBlue100_4,
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

class MainScreenSearchField extends StatelessWidget {
  const MainScreenSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: AppStyles.regular18(context).copyWith(
            color: AppLightColors.myBlack50,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
