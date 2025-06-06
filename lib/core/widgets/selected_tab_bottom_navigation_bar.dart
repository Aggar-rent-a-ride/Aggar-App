import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SelectedTabBottomNavigationBar extends StatelessWidget {
  const SelectedTabBottomNavigationBar(
      {super.key,
      required this.index,
      required this.iconImage,
      required this.label,
      required this.selectedIndex,
      required this.onTapped});
  final int index;
  final String iconImage;
  final String label;
  final int selectedIndex;
  final Function(int) onTapped;
  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
            : const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppLightColors.myBlue50_2 : Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                iconImage,
              ),
              height: 21,
              width: 21,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: isSelected ? 7.0 : 0,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Text(
                      label,
                      style: AppStyles.medium14(context).copyWith(
                        color: AppLightColors.myBlue100_1,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
