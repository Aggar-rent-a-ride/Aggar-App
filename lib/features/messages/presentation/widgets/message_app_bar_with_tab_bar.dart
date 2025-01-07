import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MessageAppBarWithTabBar extends StatelessWidget {
  const MessageAppBarWithTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Message",
                style: TextStyle(
                  color: AppColors.myBlack100,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              )
            ],
          ),
        ),
        const Gap(5),
        TabBar(
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          indicatorColor: AppColors.myBlue100_2,
          dividerColor: AppColors.myWhite100_1,
          labelColor: AppColors.myBlue100_2,
          unselectedLabelColor: AppColors.myGray100_2,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Requests'),
          ],
        ),
      ],
    );
  }
}
