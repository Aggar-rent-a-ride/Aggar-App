import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:aggar/features/main_screen/presentation/views/main_screen.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/messages_view.dart';
import 'package:aggar/features/profile/presentation/views/profile_screen.dart';
import 'package:aggar/features/settings/presentation/views/settings_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarViews extends StatefulWidget {
  const BottomNavigationBarViews({super.key});

  @override
  State<BottomNavigationBarViews> createState() =>
      _BottomNavigationBarViewsState();
}

class _BottomNavigationBarViewsState extends State<BottomNavigationBarViews> {
  int selectedIndex = 0;

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const MainScreen(),
      const MessagesView(),
      const SettingsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: AppLightColors.myWhite100_1,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: selectedIndex,
        onTapped: onTapped,
      ),
    );
  }
}
