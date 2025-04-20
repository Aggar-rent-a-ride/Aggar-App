import 'package:aggar/core/extensions/context_colors_extension.dart';
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
            color: context.theme.black50,
          ),
        ),
        const Gap(20),
      ],
      backgroundColor: Colors.transparent,
    );
  }
}
