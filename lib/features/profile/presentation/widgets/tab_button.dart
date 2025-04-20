import 'package:aggar/core/extensions/context_colors_extension.dart';
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
          color:
              isSelected ? context.theme.blue100_1 : context.theme.white100_1,
          border: Border.all(
            color:
                isSelected ? context.theme.blue100_1 : context.theme.gray100_1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: AppStyles.regular16(context).copyWith(
            color:
                isSelected ? context.theme.white100_1 : context.theme.black100,
          ),
        ),
      ),
    );
  }
}
