import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/main_screen_search_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/widgets/custom_icon.dart';

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
              color: context.theme.black50.withOpacity(0.25),
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
