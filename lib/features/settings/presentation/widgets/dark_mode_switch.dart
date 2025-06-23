import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/extensions/theme_cubit_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/cubit/theme/theme_cubit.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDarkMode = context.themeCubit.themeMode == ThemeMode.dark;
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: context.theme.blue100_1,
              borderRadius: const BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: context.theme.white100_1,
                borderRadius: const BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: ToggleSwitch(
                minWidth: 12,
                minHeight: 12,
                cornerRadius: 50,
                radiusStyle: true,
                initialLabelIndex: isDarkMode ? 0 : 1,
                totalSwitches: 2,
                labels: const ['', ''],
                onToggle: (index) {
                  context.read<ThemeCubit>().toggleTheme();
                },
                activeBgColor: [context.theme.blue100_1],
                activeFgColor: context.theme.white100_1,
                inactiveBgColor: context.theme.white100_1,
                inactiveFgColor: context.theme.blue100_1,
              ),
            ),
          ),
        );
      },
    );
  }
}
