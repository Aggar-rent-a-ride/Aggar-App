import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/name_and_email_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImageWithNameAndEmailSection extends StatelessWidget {
  const ImageWithNameAndEmailSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(
            AppAssets.assetsImagesAvatar,
          ),
        ),
        Gap(20),
        NameAndEmailSection(),
        Spacer(),
        ArrowForwardIconButton(),
      ],
    );
  }
}
