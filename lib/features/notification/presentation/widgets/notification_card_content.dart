import 'package:aggar/features/notification/presentation/widgets/notification_text_with_time_ago.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationCardContent extends StatelessWidget {
  const NotificationCardContent({
    super.key,
    required this.profileImage,
    required this.name,
    required this.actionText,
    required this.timeAgo,
    this.widget,
    required this.isfoundButton,
  });

  final String profileImage;
  final String name;
  final String actionText;
  final String timeAgo;
  final Widget? widget;
  final bool isfoundButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(profileImage),
              radius: 25,
            ),
            const Gap(15),
            NotificationTextWithTimeAgo(
              name: name,
              actionText: actionText,
              timeAgo: timeAgo,
              isfoundButton: isfoundButton,
              widget: widget,
            ),
          ],
        ),
      ],
    );
  }
}
