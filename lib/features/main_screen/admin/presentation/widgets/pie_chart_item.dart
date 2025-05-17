import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PieChartItem extends StatelessWidget {
  const PieChartItem({
    super.key,
    required this.title,
    required this.color,
    this.onTap,
  });
  final String title;
  final Color color;
  final void Function()? onTap;

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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 2,
                  )
                ]),
          ),
          const Gap(5),
          Text(
            title,
            style: AppStyles.semiBold14(context).copyWith(
              color: context.theme.black50,
            ),
          ),
        ],
      ),
    );
  }
}
