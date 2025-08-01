import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SelectedTabBottomNavigationBar extends StatelessWidget {
  const SelectedTabBottomNavigationBar(
      {super.key,
      required this.index,
      required this.iconImage,
      required this.label,
      required this.selectedIndex,
      required this.onTapped,
      this.size});
  final int index;
  final String iconImage;
  final String label;
  final int selectedIndex;
  final Function(int) onTapped;
  final double? size;
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
          color: isSelected
              ? context.theme.blue100_1.withOpacity(0.15)
              : Colors.transparent,
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
              color: context.theme.blue100_1,
              height: size ?? 21,
              width: size ?? 21,
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
                        color: context.theme.blue100_1,
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
