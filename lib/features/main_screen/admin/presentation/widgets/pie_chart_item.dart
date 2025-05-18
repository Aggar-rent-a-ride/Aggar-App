import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChartItem extends StatelessWidget {
  const ChartItem({
    super.key,
    required this.title,
    required this.color,
    this.onTap,
    this.isSelected = false,
  });

  final String title;
  final Color color;
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? Colors.black26 : Colors.black12,
                  offset: const Offset(0, 0),
                  blurRadius: isSelected ? 4 : 2,
                ),
              ],
              border:
                  isSelected ? Border.all(color: Colors.black, width: 1) : null,
            ),
          ),
          const Gap(5),
          Text(
            title,
            style: AppStyles.semiBold14(context).copyWith(
              color:
                  isSelected ? context.theme.black100 : context.theme.black50,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
