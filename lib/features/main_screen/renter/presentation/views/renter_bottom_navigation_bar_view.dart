import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/main_screen/renter/presentation/views/main_screen.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/messages_view.dart';
import 'package:aggar/features/new_vehicle/data/cubits/add_vehicle_cubit/add_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/presentation/views/add_vehicle_screen.dart';
import 'package:aggar/features/settings/presentation/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _resetVehicleForm() {
    context.read<AddVehicleCubit>().reset();
    context.read<MainImageCubit>().reset();
    context.read<AdditionalImageCubit>().reset();
    context.read<MapLocationCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const MainScreen(),
      const MessagesView(),
      const SettingsScreen(),
      const MainScreen(),
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
        floatingActionButton: FloatingActionButton(
          heroTag: "Dddd",
          onPressed: () {
            _resetVehicleForm();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddVehicleScreen(),
              ),
            );
          },
          backgroundColor: context.theme.blue100_1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.add,
            color: context.theme.white100_1,
            size: 30,
          ),
        ),
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
