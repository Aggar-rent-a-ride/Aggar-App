import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/addetinal_technical_information.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/indicator_section.dart';
import 'package:flutter/material.dart';

class TechnicalInformationSection extends StatelessWidget {
  const TechnicalInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //TODO: the font not handle yet
        Text(
          "Technical Information",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.myGray100_3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const IndicatorSection(),
        const AddetinalTechnicalInformation()
      ],
    );
  }
}
