import 'package:aggar/core/extensions/context_colors_extension.dart';
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
          color: context.theme.blue100_1,
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
          activeBgColor: [context.theme.white100_1],
          activeFgColor: context.theme.blue100_1,
          inactiveBgColor: context.theme.blue100_1,
          inactiveFgColor: context.theme.white100_1,
        ),
      ),
    );
  }
}
