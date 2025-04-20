import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_screen_location_icon_and_location_text.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_screen_search_field_with_filter_icon.dart';
import 'package:aggar/features/main_screen/presentation/widgets/notification_icon_button.dart';
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
                      .copyWith(color: context.theme.white50_1),
                ),
                const Gap(5),
                const MainScreenLocationIconAndLocationText(),
              ],
            ),
            const NotificationIconButton(),
          ],
        ),
        const Gap(20),
        const MainScreenSearchFieldWithFilterIcon()
      ],
    );
  }
}
