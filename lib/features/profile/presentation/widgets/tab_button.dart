
import 'package:aggar/core/utils/app_colors.dart';
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
          color: isSelected ? AppColors.myBlue100_1 : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.myBlue100_1 : AppColors.myGray100_1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
