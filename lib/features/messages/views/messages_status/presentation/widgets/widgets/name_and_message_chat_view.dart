import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NameAndMessageChatView extends StatelessWidget {
  const NameAndMessageChatView({
    super.key,
    required this.name,
    required this.msg,
  });
  final String name;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.bold20(context).copyWith(
              color: AppColors.myBlue100_2,
            ),
          ),
          const Gap(6),
          Text(
            msg,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.medium16(context)
                .copyWith(color: AppColors.myBlack50),
          ),
        ],
      ),
    );
  }
}
