import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/renter/presentation/widgets/renter_vehicles_list.dart';
import 'package:aggar/features/profile/presentation/widgets/review_user_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import '../../../../../../core/cubit/user_cubit/user_info_cubit.dart';
import '../../../../../../core/cubit/user_cubit/user_info_state.dart';
import 'booking_history_list.dart';

class RenterProfileTabBarSection extends StatefulWidget {
  const RenterProfileTabBarSection({super.key});

  @override
  State<RenterProfileTabBarSection> createState() =>
      _RenterProfileTabBarSectionState();
}

class _RenterProfileTabBarSectionState extends State<RenterProfileTabBarSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedTabIndex = _tabController.index;
        });
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      selectedTabIndex = index;
    });
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, userState) {
        String? userId;
        if (userState is UserInfoSuccess) {
          userId = userState.userInfoModel.id.toString();
        }

        return Column(
          children: [
            TabBar(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              controller: _tabController,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              indicatorColor: context.theme.blue100_1,
              dividerColor: context.theme.black25,
              labelColor: context.theme.blue100_1,
              unselectedLabelColor: context.theme.black50,
              labelStyle: AppStyles.bold18(context)
                  .copyWith(color: context.theme.blue100_2),
              unselectedLabelStyle: AppStyles.bold18(context).copyWith(
                color: context.theme.black25,
              ),
              tabs: const [
                Tab(text: 'Vehicles'),
                Tab(text: 'Reviews'),
                Tab(text: 'Booking'),
              ],
            ),
            ExpandablePageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                const RenterVehiclesList(),
                ReviewUserSection(userId: userId?.toString() ?? ''),
                const BookingHistoryList(),
              ],
            ),
          ],
        );
      },
    );
  }
}
