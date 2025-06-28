import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'see more',
            style: AppStyles.medium15(context).copyWith(
              color: context.theme.blue100_1,
            ),
          ),
          const Gap(5),
          Icon(
            Icons.arrow_forward_ios,
            color: context.theme.blue100_1,
            size: 12,
          ),
        ],
      ),
    );
  }
}
