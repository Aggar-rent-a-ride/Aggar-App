import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/views/about_tab_bar_view.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/views/properities_tab_bar_view.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/views/review_tab_bar_view.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:latlong2/latlong.dart';

class TabBarSection extends StatefulWidget {
  const TabBarSection({
    super.key,
    required this.vehicleColor,
    required this.vehicleOverView,
    required this.vehiceSeatsNo,
    required this.images,
    required this.mainImage,
    required this.vehicleHealth,
    required this.vehicleStatus,
    required this.vehicleAddress,
    required this.vehicleLongitude,
    required this.vehicleLatitude,
    this.initialLocation,
    this.onLocationSelected,
  });
  final String vehicleColor;
  final String vehicleOverView;
  final String vehiceSeatsNo;
  final List<File?> images;
  final File mainImage;
  final String vehicleHealth;
  final String vehicleStatus;
  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  final LatLng? initialLocation;
  final Function(LatLng, String)? onLocationSelected;
  @override
  // ignore: library_private_types_in_public_api
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
          indicatorColor: AppLightColors.myBlue100_2,
          dividerColor: AppLightColors.myBlack10,
          labelColor: AppLightColors.myBlue100_2,
          unselectedLabelColor: AppLightColors.myGray100_2,
          labelStyle: AppStyles.bold18(context)
              .copyWith(color: AppLightColors.myBlue100_2),
          unselectedLabelStyle: AppStyles.bold18(context)
              .copyWith(color: AppLightColors.myBlack25),
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
            _pageController.jumpToPage(index);
          },
        ),
        ExpandablePageView(
          controller: _pageController,
          children: [
            AboutTabBarView(
              vehicleAddress: widget.vehicleAddress,
              vehicleLongitude: widget.vehicleLongitude,
              vehicleLatitude: widget.vehicleLatitude,
              initialLocation: widget.initialLocation,
              onLocationSelected: widget.onLocationSelected,
            ),
            ProperitiesTabBarView(
              vehicleHealth: widget.vehicleHealth,
              vehicleStatus: widget.vehicleStatus,
              vehicleColor: widget.vehicleColor,
              vehicleOverView: widget.vehicleOverView,
              vehiceSeatsNo: widget.vehiceSeatsNo,
              images: widget.images,
              mainImage: widget.mainImage,
            ),
            const ReviewTabBarView(),
          ],
        ),
      ],
    );
  }
}
