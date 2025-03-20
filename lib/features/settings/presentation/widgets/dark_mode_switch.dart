import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppLightColors.myBlue100_1,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              25,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppLightColors.myWhite100_1,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                25,
              ),
            ),
          ),
          child: ToggleSwitch(
            minWidth: 12,
            minHeight: 12,
            cornerRadius: 50,
            radiusStyle: true,
            initialLabelIndex: 1,
            totalSwitches: 2,
            labels: const ['', ''],
            onToggle: (index) {},
            activeBgColor: [AppLightColors.myBlue100_1],
            activeFgColor: AppLightColors.myWhite100_1,
            inactiveBgColor: AppLightColors.myWhite100_1,
            inactiveFgColor: AppLightColors.myBlue100_1,
          ),
        ),
      ),
    );
  }
}
