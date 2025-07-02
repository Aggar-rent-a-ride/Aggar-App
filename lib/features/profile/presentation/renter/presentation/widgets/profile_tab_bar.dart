import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_cubit.dart';
import 'package:aggar/features/profile/presentation/renter/presentation/widgets/renter_vehicles_list.dart';
import 'package:aggar/features/profile/presentation/widgets/review_user_section.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/cubit/user_cubit/user_info_cubit.dart';
import '../../../../../../core/cubit/user_cubit/user_info_state.dart';

class RenterProfileTabBarSection extends StatefulWidget {
  const RenterProfileTabBarSection({super.key});

  @override
  State<RenterProfileTabBarSection> createState() =>
      _RenterProfileTabBarSectionState();
}

class _RenterProfileTabBarSectionState extends State<RenterProfileTabBarSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().fetchUserInfo("20",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6Ijg1NjgyNzRlLWZhMWUtNGEyZS1hOTVlLTJhMGI3ZWYwNTlhNyIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc1MTI0NjY3NywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.6FhN9OCYhe2PHJUksiyJ0f_ac7o7fP7t5579V8z8eJU");
    context.read<ProfileCubit>().fetchRenterVehicles(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6Ijg1NjgyNzRlLWZhMWUtNGEyZS1hOTVlLTJhMGI3ZWYwNTlhNyIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc1MTI0NjY3NywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.6FhN9OCYhe2PHJUksiyJ0f_ac7o7fP7t5579V8z8eJU");
    context.read<ReviewCubit>().getUserReviews("20",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6Ijg1NjgyNzRlLWZhMWUtNGEyZS1hOTVlLTJhMGI3ZWYwNTlhNyIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc1MTI0NjY3NywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.6FhN9OCYhe2PHJUksiyJ0f_ac7o7fP7t5579V8z8eJU");
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
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
                Tab(text: 'Vehicles'),
                Tab(text: 'Reviews'),
                Tab(text: "Booking"),
              ],
            ),
            _selectedTabIndex == 0
                ? const RenterVehiclesList()
                : _selectedTabIndex == 1
                    ? ReviewUserSection(userId: userId.toString())
                    : const SizedBox(),
          ],
        );
      },
    );
  }
}
