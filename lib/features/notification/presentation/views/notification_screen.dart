import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/notification/presentation/widgets/accept_or_feedback_button.dart';
import 'package:aggar/features/notification/presentation/widgets/deny_button.dart';
import 'package:aggar/features/notification/presentation/widgets/notification_card.dart';
import 'package:aggar/features/notification/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
              isfoundButton: true,
              widget: Row(
                children: [
                  AcceptOrFeedbackButton(
                    title: "Accept",
                    onPressed: () {},
                  ),
                  const Gap(8),
                  DenyButton(
                    onPressed: () {},
                  )
                ],
              ),
            ),
            NotificationCard(
              profileImage: AppAssets.assetsImagesNotificationPic1,
              name: 'Jenny Wilson',
              actionText: 'send a request to start chat',
              timeAgo: '5 min ago',
              isfoundButton: true,
              widget: Row(
                children: [
                  AcceptOrFeedbackButton(
                    title: "Accept",
                    onPressed: () {},
                  ),
                  const Gap(8),
                  DenyButton(
                    onPressed: () {},
                  )
                ],
              ),
            ),
            const NotificationCard(
              profileImage: AppAssets.assetsImagesNotificationPic2,
              name: 'Annette Black',
              actionText: 'have completed the steps to book the BMW',
              timeAgo: '5 min ago',
              isfoundButton: false,
            ),
            NotificationCard(
              profileImage: AppAssets.assetsImagesNotificationPic1,
              name: 'Robert Fox',
              actionText: 'send a feedback on Tesla Model',
              timeAgo: '1 hr ago',
              isfoundButton: true,
              widget: AcceptOrFeedbackButton(
                title: "Send a Feedback",
                onPressed: () {},
              ),
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
              isfoundButton: true,
              widget: AcceptOrFeedbackButton(
                title: "Send a Feedback",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
