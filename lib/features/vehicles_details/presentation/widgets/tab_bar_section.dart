import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/views/about_tab_bar_view.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/views/properities_tab_bar_view.dart';
import 'package:flutter/material.dart';

class TabBarSection extends StatelessWidget {
  const TabBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          indicatorColor: AppColors.myBlue100_2,
          dividerColor: AppColors.myBlack10,
          labelColor: AppColors.myBlue100_2,
          unselectedLabelColor: AppColors.myGray100_2,
          tabs: const [
            Tab(text: 'About'),
            Tab(text: 'Properties'),
            Tab(text: 'Reviews'),
          ],
        ),
        const SizedBox(
          height: 500,
          child: TabBarView(
            children: [
              Center(child: AboutTabBarView()),
              Center(child: ProperitiesTabBarView()),
              Center(child: Text('Settings Tab')),
            ],
          ),
        ),
      ],
    );
  }
}
