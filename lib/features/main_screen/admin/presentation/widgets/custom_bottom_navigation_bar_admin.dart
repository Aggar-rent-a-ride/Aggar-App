import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/widgets/selected_tab_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBarAdmin extends StatelessWidget {
  const CustomBottomNavigationBarAdmin(
      {super.key, required this.selectedIndex, required this.onTapped});
  final int selectedIndex;
  final Function(int) onTapped;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SelectedTabBottomNavigationBar(
                iconImage: AppAssets.assetsIconsHome,
                index: 0,
                label: 'Home',
                onTapped: onTapped,
                selectedIndex: selectedIndex,
              ),
              SelectedTabBottomNavigationBar(
                iconImage: AppAssets.assetsIconsVehicleServices,
                size: 26,
                index: 1,
                label: 'Services',
                onTapped: onTapped,
                selectedIndex: selectedIndex,
              ),
              SelectedTabBottomNavigationBar(
                iconImage: AppAssets.assetsIconsChats,
                size: 20,
                index: 2,
                label: 'Messages',
                onTapped: onTapped,
                selectedIndex: selectedIndex,
              ),
              SelectedTabBottomNavigationBar(
                iconImage: AppAssets.assetsIconsProfile,
                index: 3,
                size: 20,
                label: 'Profile',
                onTapped: onTapped,
                selectedIndex: selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
