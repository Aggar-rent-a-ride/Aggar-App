import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_text_and_icon_section_addetinal_technical_information.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddetinalTechnicalInformation extends StatelessWidget {
  const AddetinalTechnicalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextAndIconSectionAddetinalTechnicalInformation(
              title: 'Motor power :',
              imageIcon: AppAssets.assetsIconsMotor,
              subtitle: "120 hp",
            ),
            Gap(8),
            CustomTextAndIconSectionAddetinalTechnicalInformation(
              title: 'Engine Capacity :',
              imageIcon: AppAssets.assetsIconsEngine,
              subtitle: "1580 cc",
            ),
            Gap(8),
            CustomTextAndIconSectionAddetinalTechnicalInformation(
              title: 'Fuel :',
              imageIcon: AppAssets.assetsIconsFuel,
              subtitle: "Diesal",
            ),
          ],
        ),
        Gap(12),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextAndIconSectionAddetinalTechnicalInformation(
              title: 'Climate Control :',
              imageIcon: AppAssets.assetsIconsClimate,
              subtitle: "16 C ",
            ),
            Gap(8),
            CustomTextAndIconSectionAddetinalTechnicalInformation(
              title: 'Seats no :',
              imageIcon: AppAssets.assetsIconsSeats,
              subtitle: "6 person  ",
            ),
          ],
        ),
      ],
    );
  }
}
