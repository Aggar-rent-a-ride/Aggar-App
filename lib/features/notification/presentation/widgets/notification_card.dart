import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/notification/presentation/views/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String actionText;
  final String timeAgo;
  final List<ActionButton>? buttons;

  const NotificationCard({
    required this.profileImage,
    required this.name,
    required this.actionText,
    required this.timeAgo,
    this.buttons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(profileImage),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: AppColors.myBlack100),
                          children: [
                            TextSpan(
                              text: name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' $actionText'),
                          ],
                        ),
                      ),
                      const Gap(5),
                      Text(
                        timeAgo,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (buttons != null) ...[
              const Gap(12),
              Row(
                children: buttons!
                    .map((button) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: button.color,
                            ),
                            child: Text(button.text),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
