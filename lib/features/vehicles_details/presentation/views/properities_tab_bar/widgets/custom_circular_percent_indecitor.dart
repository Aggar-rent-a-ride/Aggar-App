import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/indicator_information.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomCircularPercentIndecitor extends StatelessWidget {
  const CustomCircularPercentIndecitor({
    super.key,
    required this.percentage,
    required this.title,
    required this.subtitle,
  });

  final double percentage;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: CircularPercentIndicator(
        animation: true,
        circularStrokeCap: CircularStrokeCap.round,
        linearGradient: LinearGradient(
          colors: [
            AppColors.myBlue100_2,
            AppColors.myBlue100_2,
          ],
          stops: const [0.0, 0.1],
        ),
        radius: 50,
        lineWidth: 3,
        percent: percentage,
        startAngle: 0,
        backgroundColor: Colors.transparent,
        center: IndicatorInformation(
          title: title,
          subTitle: subtitle,
        ),
        // changes here
      ),
    );
  }
}
