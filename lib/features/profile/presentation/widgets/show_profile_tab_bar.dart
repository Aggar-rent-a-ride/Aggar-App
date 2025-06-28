import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ShowProfileTabBar extends StatelessWidget {
  const ShowProfileTabBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      controller: _tabController,
      padding: EdgeInsets.zero,
      indicatorPadding: EdgeInsets.zero,
      indicatorColor: context.theme.blue100_1,
      dividerColor: context.theme.black10,
      labelColor: context.theme.blue100_1,
      unselectedLabelColor: context.theme.gray100_2,
      labelStyle:
          AppStyles.bold18(context).copyWith(color: context.theme.blue100_1),
      unselectedLabelStyle: AppStyles.bold18(context).copyWith(
        color: context.theme.black25,
      ),
      tabs: const [
        Tab(text: 'Location'),
        Tab(text: 'Reviews'),
      ],
    );
  }
}
