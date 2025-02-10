import 'package:aggar/features/notification/presentation/widgets/notification_card_content.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card_style.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String actionText;
  final String timeAgo;
  final Widget? widget;
  final bool isfoundButton;

  const NotificationCard({
    required this.profileImage,
    required this.name,
    required this.actionText,
    required this.timeAgo,
    super.key,
    this.widget,
    required this.isfoundButton,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationCardStyle(
      widget: NotificationCardContent(
        profileImage: profileImage,
        name: name,
        actionText: actionText,
        timeAgo: timeAgo,
        isfoundButton: isfoundButton,
        widget: widget,
      ),
    );
  }
}
