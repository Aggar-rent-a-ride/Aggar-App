import 'package:aggar/features/notification/presentation/widgets/action_button.dart';
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
    required this.buttons,
  });

  final String profileImage;
  final String name;
  final String actionText;
  final String timeAgo;
  final List<ActionButton>? buttons;

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
                name: name, actionText: actionText, timeAgo: timeAgo),
          ],
        ),
        if (buttons != null) ...[
          const Gap(12),
          Row(
            children: buttons!
                .map(
                  (button) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: button.color,
                      ),
                      child: Text(button.text),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
