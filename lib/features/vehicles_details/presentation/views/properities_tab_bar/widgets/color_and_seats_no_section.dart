import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/custom_text_and_icon_section_addetinal_technical_information.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart' show Gap;

class ColorAndSeatsNoSection extends StatelessWidget {
  const ColorAndSeatsNoSection({
    super.key,
    required this.color,
    required this.seatsNo,
  });
  final String color;
  final String seatsNo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextAndIconSection(
          title: color,
          width: 5,
          imageIcon: AppAssets.assetsIconsColor,
        ),
        const Gap(10),
        TextAndIconSection(
          title: seatsNo,
          imageIcon: AppAssets.assetsIconsSeatsno,
        ),
      ],
    );
  }
}
