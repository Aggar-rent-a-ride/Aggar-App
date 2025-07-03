import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/widgets/saved_vehicle_section.dart';
import 'package:aggar/features/profile/presentation/widgets/review_user_section.dart';
import 'package:aggar/features/profile/presentation/renter/presentation/widgets/booking_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubit/user_cubit/user_info_cubit.dart';
import '../../../../../../core/cubit/user_cubit/user_info_state.dart';

class ProfileTabBarSection extends StatefulWidget {
  const ProfileTabBarSection({super.key});

  @override
  State<ProfileTabBarSection> createState() => _ProfileTabBarSectionState();
}

class _ProfileTabBarSectionState extends State<ProfileTabBarSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              indicatorColor: context.theme.blue100_2,
              dividerColor: context.theme.black25,
              labelColor: context.theme.blue100_2,
              unselectedLabelColor: context.theme.black50,
              labelStyle: AppStyles.bold18(context)
                  .copyWith(color: context.theme.blue100_2),
              unselectedLabelStyle: AppStyles.bold18(context).copyWith(
                color: context.theme.black25,
              ),
              tabs: const [
                Tab(text: 'Saved'),
                Tab(text: 'Reviews'),
                Tab(text: 'Booking'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height + 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  const SavedVehicleSection(),
                  ReviewUserSection(userId: userId?.toString() ?? ''),
                  const BookingHistoryList(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
