import 'package:aggar/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AppLightColors.myBlue100_1,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              10,
            ),
          ),
        ),
        child: ToggleSwitch(
          fontSize: 10,
          minWidth: 35,
          minHeight: 20,
          radiusStyle: true,
          initialLabelIndex: 1,
          totalSwitches: 2,
          labels: const ['EN', 'AR'],
          onToggle: (index) {},
          activeBgColor: [AppLightColors.myWhite100_1],
          activeFgColor: AppLightColors.myBlue100_1,
          inactiveBgColor: AppLightColors.myBlue100_1,
          inactiveFgColor: AppLightColors.myWhite100_1,
        ),
      ),
    );
  }
}
