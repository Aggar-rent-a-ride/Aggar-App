import 'package:flutter/material.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/views/about_tab_bar_view.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/views/properities_tab_bar_view.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/views/review_tab_bar_view.dart';

class TabBarSection extends StatefulWidget {
  const TabBarSection({super.key});

  @override
  _TabBarSectionState createState() => _TabBarSectionState();
}

class _TabBarSectionState extends State<TabBarSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          indicatorColor: AppColors.myBlue100_2,
          dividerColor: AppColors.myBlack10,
          labelColor: AppColors.myBlue100_2,
          unselectedLabelColor: AppColors.myGray100_2,
          labelStyle:
              AppStyles.bold18(context).copyWith(color: AppColors.myBlue100_2),
          unselectedLabelStyle:
              AppStyles.bold18(context).copyWith(color: AppColors.myBlack25),
          tabs: const [
            Tab(
              child: Text("About"),
            ),
            Tab(
              child: Text("Properties"),
            ),
            Tab(
              child: Text("Reviews"),
            ),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index); // Jump to the selected page
          },
        ),
        SizedBox(
            height: 500,
            child: PageView(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable swipe gestures
              children: const [
                Center(child: AboutTabBarView()),
                Center(child: ProperitiesTabBarView()),
                Center(child: ReviewTabBarView()),
              ],
            )),
      ],
    );
  }
}
