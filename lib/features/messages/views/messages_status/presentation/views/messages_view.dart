import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/all_messages_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/app_styles.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: AppColors.myBlack50,
        toolbarHeight: 70,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Messages',
            style: AppStyles.bold24(context),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: AppColors.myBlack50,
            ),
          ),
          const Gap(20),
        ],
        backgroundColor: AppColors.myWhite100_1,
      ),
      backgroundColor: AppColors.myWhite100_1,
      body: const AllMessagesView(),
    );
  }
}
