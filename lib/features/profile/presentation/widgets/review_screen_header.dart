import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReviewScreenHeader extends StatelessWidget {
  const ReviewScreenHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.blue100_1,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 55,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.theme.white100_1,
              size: 20,
            ),
          ),
          const Gap(5),
          Text(
            "All Reviews",
            style: AppStyles.bold20(context).copyWith(
              color: context.theme.white100_1,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
