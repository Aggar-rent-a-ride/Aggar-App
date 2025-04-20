import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/app_styles.dart';

class ImageAndNamePersonMessage extends StatelessWidget {
  const ImageAndNamePersonMessage({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(AppAssets.assetsImagesAvatar),
        ),
        const Gap(10),
        Text(
          name,
          style: AppStyles.bold20(context).copyWith(
            color: context.theme.white100_1,
          ),
        ),
      ],
    );
  }
}
