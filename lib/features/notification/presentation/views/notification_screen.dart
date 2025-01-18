import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card.dart';
import 'package:aggar/features/notification/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          const SectionHeader(title: 'Today', markTitle: 'Mark all as read'),
          NotificationCard(
            profileImage: AppAssets.assetsImagesNotificationPic1,
            name: 'Jenny Wilson',
            actionText: 'send a request to start chat',
            timeAgo: '5 min ago',
            buttons: [
              ActionButton(
                  text: 'Accept',
                  color: AppColors.myBlue100_1,
                  onPressed: () {}),
              ActionButton(
                  text: 'Deny', color: AppColors.myGray100_2, onPressed: () {}),
            ],
          ),
          const NotificationCard(
            profileImage: AppAssets.assetsImagesNotificationPic2,
            name: 'Annette Black',
            actionText: 'have completed the steps to book the BMW',
            timeAgo: '5 min ago',
          ),
          NotificationCard(
            profileImage: AppAssets.assetsImagesNotificationPic1,
            name: 'Robert Fox',
            actionText: 'send a feedback on Tesla Model X',
            timeAgo: '1 hr ago',
            buttons: [
              ActionButton(
                  text: 'View a feedback',
                  color: Colors.blue,
                  onPressed: () {}),
            ],
          ),
          const SectionHeader(title: 'Earlier', markTitle: 'Mark all as read'),
          NotificationCard(
            profileImage: AppAssets.assetsImagesNotificationPic1,
            name: 'Robert Fox',
            actionText: 'send a feedback on Tesla Model X',
            timeAgo: '1 hr ago',
            buttons: [
              ActionButton(
                text: 'View a feedback',
                color: Colors.blue,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// not as i want

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const ActionButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(text),
    );
  }
}
