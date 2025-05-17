import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:aggar/features/main_screen/renter/presentation/views/main_screen.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/messages_view.dart';
import 'package:aggar/features/settings/presentation/views/settings_screen.dart';
import 'package:flutter/material.dart';

class RenterBottomNavigationBarView extends StatefulWidget {
  const RenterBottomNavigationBarView({super.key});

  @override
  State<RenterBottomNavigationBarView> createState() =>
      _RenterBottomNavigationBarViewState();
}

class _RenterBottomNavigationBarViewState
    extends State<RenterBottomNavigationBarView> {
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
      const MainScreen(),
    ];
    return Scaffold(
      backgroundColor: context.theme.white100_1,
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
