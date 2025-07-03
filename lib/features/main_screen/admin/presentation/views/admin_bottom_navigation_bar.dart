import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/main_screen.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/custom_bottom_navigation_bar_admin.dart';
import 'package:aggar/features/notification/presentation/views/notification_screen.dart';
import 'package:aggar/features/profile/presentation/admin/presentation/views/admin_profile_screen.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/view/vehicle_brand_with_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../messages/views/messages_status/presentation/views/messages_view.dart';

class AdminBottomNavigationBar extends StatefulWidget {
  const AdminBottomNavigationBar({super.key});

  @override
  State<AdminBottomNavigationBar> createState() =>
      _AdminBottomNavigationBarState();
}

class _AdminBottomNavigationBarState extends State<AdminBottomNavigationBar>
    with WidgetsBindingObserver {
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
      const VehicleBrandWithTypeScreen(),
      const MessagesView(),
      const NotificationScreen(),
      const AdminProfileScreen()
    ];

    return BlocListener<TokenRefreshCubit, TokenRefreshState>(
      listener: (context, state) {
        if (state is TokenRefreshFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Session expired. Please login again.",
              SnackBarType.error,
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
        bottomNavigationBar: CustomBottomNavigationBarAdmin(
          selectedIndex: selectedIndex,
          onTapped: onTapped,
        ),
      ),
    );
  }
}
