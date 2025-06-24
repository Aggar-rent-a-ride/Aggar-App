import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/widgets/main_screen_location_icon_and_location_text.dart';
import 'package:aggar/features/main_screen/widgets/main_screen_search_field_with_filter_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key, this.onPressed});
  final void Function()? onPressed;
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
                  style: AppStyles.regular14(context).copyWith(
                      color: AppConstants.myWhite100_1.withOpacity(0.50)),
                ),
                const Gap(5),
                const MainScreenLocationIconAndLocationText(),
              ],
            ),
          ],
        ),
        const Gap(20),
        const MainScreenSearchFieldWithFilterIcon()
      ],
    );
  }
}
