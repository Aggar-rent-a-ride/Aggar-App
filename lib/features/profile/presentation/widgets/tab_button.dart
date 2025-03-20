import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final int index;
  final String title;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const TabButton({
    super.key,
    required this.index,
    required this.title,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppLightColors.myBlue100_1 : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppLightColors.myBlue100_1
                : AppLightColors.myGray100_1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: AppStyles.regular16(context).copyWith(
            color: isSelected
                ? AppLightColors.myWhite100_1
                : AppLightColors.myBlack100,
          ),
        ),
      ),
    );
  }
}
