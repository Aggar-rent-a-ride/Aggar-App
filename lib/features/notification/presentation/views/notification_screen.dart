import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/notification/presentation/widgets/action_button.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card.dart';
import 'package:aggar/features/notification/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_styles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Notifications',
            style: AppStyles.bold24(context),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  onPressed: () {},
                ),
                ActionButton(
                    text: 'Deny',
                    color: AppColors.myGray100_2,
                    onPressed: () {}),
              ],
            ),
            NotificationCard(
              profileImage: AppAssets.assetsImagesNotificationPic1,
              name: 'Jenny Wilson',
              actionText: 'send a request to start chat',
              timeAgo: '5 min ago',
              buttons: [
                ActionButton(
                  text: 'Accept',
                  color: AppColors.myBlue100_1,
                  onPressed: () {},
                ),
                ActionButton(
                    text: 'Deny',
                    color: AppColors.myGray100_2,
                    onPressed: () {}),
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
              actionText: 'send a feedback on Tesla Model',
              timeAgo: '1 hr ago',
              buttons: [
                ActionButton(
                    text: 'View a feedback',
                    color: Colors.blue,
                    onPressed: () {}),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: SectionHeader(
                  title: 'Earlier', markTitle: 'Mark all as read'),
            ),
            NotificationCard(
              profileImage: AppAssets.assetsImagesNotificationPic1,
              name: 'Robert Fox',
              actionText: 'send a feedback on Tesla Model',
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
      ),
    );
  }
}
