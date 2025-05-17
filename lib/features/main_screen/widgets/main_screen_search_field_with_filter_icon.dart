import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/main_screen/widgets/main_screen_search_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainScreenSearchFieldWithFilterIcon extends StatelessWidget {
  const MainScreenSearchFieldWithFilterIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: MainScreenSearchField(),
        ),
        const Gap(10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.12,
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.gray100_2.withOpacity(0.25),
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
    );
  }
}
