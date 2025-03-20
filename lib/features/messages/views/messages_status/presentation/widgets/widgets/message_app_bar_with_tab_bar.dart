import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MessageAppBarWithTabBar extends StatelessWidget {
  const MessageAppBarWithTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40,
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
            color: AppLightColors.myBlack50,
          ),
        ),
        const Gap(20),
      ],
      backgroundColor: Colors.transparent,
    );
  }
}
