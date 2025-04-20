import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationTextWithTimeAgo extends StatelessWidget {
  const NotificationTextWithTimeAgo({
    super.key,
    required this.name,
    required this.actionText,
    required this.timeAgo,
    this.widget,
    required this.isfoundButton,
  });

  final String name;
  final String actionText;
  final String timeAgo;
  final Widget? widget;
  final bool isfoundButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppStyles.medium18(context).copyWith(
                color: context.theme.black50,
              ),
              children: [
                TextSpan(
                  text: name,
                  style: AppStyles.semiBold18(context).copyWith(
                    color: context.theme.black100,
                  ),
                ),
                TextSpan(text: ' $actionText'),
              ],
            ),
          ),
          const Gap(5),
          Text(
            timeAgo,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          isfoundButton
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: widget!,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
