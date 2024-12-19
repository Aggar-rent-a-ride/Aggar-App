import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/custom_indicator_with_text.dart';
import 'package:flutter/material.dart';

class IndicatorSection extends StatelessWidget {
  const IndicatorSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIndicatorWithText(
                value: 250,
                title: '250',
                subtitle: "km",
                maxValue: 400,
                outterText: 'Speed',
              ),
              CustomIndicatorWithText(
                value: 250,
                title: '250',
                subtitle: "km",
                maxValue: 400,
                outterText: 'Speed',
              ),
              CustomIndicatorWithText(
                value: 250,
                title: '250',
                subtitle: "km",
                maxValue: 400,
                outterText: 'Speed',
              )
            ],
          ),
        ),
      ],
    );
  }
}
