import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
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
import 'booking_history_list.dart'; // Import the new booking history widget

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
    _initializeWithToken();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  Future<void> _initializeWithToken() async {
    try {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final accessToken = await tokenCubit.getAccessToken();

      if (accessToken != null) {
        if (mounted) {
          context.read<ProfileCubit>().fetchRenterVehicles(accessToken);
        }

        // Get user ID and fetch reviews
        await _fetchUserReviewsWithToken(accessToken);
      } else {
        print('No valid access token available');
      }
    } catch (e) {
      print('Error initializing with token: $e');
    }
  }

  Future<void> _fetchUserReviewsWithToken(String accessToken) async {
    try {
      final userInfoCubit = context.read<UserInfoCubit>();
      final userState = userInfoCubit.state;

      String? userId;
      if (userState is UserInfoSuccess) {
        userId = userState.userInfoModel.id.toString();
      } else {}

      if (userId != null && mounted) {
        context.read<ReviewCubit>().getUserReviews(userId, accessToken);
      }
    } catch (e) {
      print('Error fetching user reviews: $e');
    }
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
              unselectedLabelColor: context.theme.gray100_2,
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
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.6, // Fixed height instead of Expanded
              child: TabBarView(
                controller: _tabController,
                children: [
                  const RenterVehiclesList(),
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
