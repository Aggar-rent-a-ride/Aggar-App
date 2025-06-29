import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/main_screen/renter/presentation/views/main_screen.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/messages_view.dart';
import 'package:aggar/features/notification/presentation/views/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../profile/presentation/renter/presentation/views/renter_profile_screen.dart';

class RenterBottomNavigationBarView extends StatefulWidget {
  const RenterBottomNavigationBarView({super.key});

  @override
  State<RenterBottomNavigationBarView> createState() =>
      _RenterBottomNavigationBarViewState();
}

class _RenterBottomNavigationBarViewState
    extends State<RenterBottomNavigationBarView> with WidgetsBindingObserver {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeTokenRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshTokenIfNeeded();
    }
  }

  void _initializeTokenRefresh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTokenIfNeeded();
    });
  }

  void _refreshTokenIfNeeded() {
    final tokenRefreshCubit = context.read<TokenRefreshCubit>();
    tokenRefreshCubit.ensureValidToken();
  }

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
      const NotificationScreen(),
      const RenterProfileScreen()
    ];

    return BlocListener<TokenRefreshCubit, TokenRefreshState>(
      listener: (context, state) {
        if (state is TokenRefreshFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignInView()));
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
