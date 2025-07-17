import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/helper/show_dialog.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_main_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/main_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Remove the SignalR initialization from here
    // Let MainCubit handle all initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only trigger the cubit initialization
      context.read<MainCubit>().initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        print('MainScreen - MainCubit state changed: ${state.runtimeType}');

        if (state is MainAuthError) {
          print('MainAuthError occurred: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Auth Error: ${state.message}",
              SnackBarType.error,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInView()),
            (route) => false,
          );
        } else if (state is MainDisconnected) {
          print('MainDisconnected state - showing no network dialog');
          showNoNetworkDialog(context);
        } else if (state is MainConnected) {
          print('MainConnected state - app should show main content');
        }
      },
      builder: (context, state) {
        print('MainScreen - Building with state: ${state.runtimeType}');

        return BlocListener<TokenRefreshCubit, TokenRefreshState>(
          listener: (context, tokenState) {
            print('TokenRefreshCubit state changed: ${tokenState.runtimeType}');

            if (tokenState is TokenRefreshSuccess) {
              print('Token refresh successful, notifying MainCubit');
              context
                  .read<MainCubit>()
                  .handleTokenRefreshSuccess(tokenState.accessToken);
            } else if (tokenState is TokenRefreshFailure) {
              print('Token refresh failed: ${tokenState.errorMessage}');
              context
                  .read<MainCubit>()
                  .handleTokenRefreshFailure(tokenState.errorMessage);
            }
          },
          child: BlocConsumer<VehicleCubit, VehicleState>(
            listener: (context, vehicleState) {
              if (vehicleState is VehicleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    context,
                    "Error",
                    "Vehicle Error: ${vehicleState.message}",
                    SnackBarType.error,
                  ),
                );
              }
            },
            builder: (context, vehicleState) {
              print(
                  'MainScreen - Rendering based on state: ${state.runtimeType}');

              if (state is MainLoading || state is MainInitial) {
                print(
                    'Showing LoadingMainScreen for state: ${state.runtimeType}');
                return const Scaffold(body: LoadingMainScreen());
              } else if (state is MainDisconnected) {
                print('Showing LoadingMainScreen for MainDisconnected state');
                return Scaffold(
                  backgroundColor: context.theme.white100_1,
                  body: const LoadingMainScreen(),
                );
              } else if (state is MainConnected) {
                print('Showing MainScreenBody for MainConnected state');
                return Scaffold(
                  backgroundColor: context.theme.white100_1,
                  body: MainScreenBody(
                    state: state,
                  ),
                );
              } else if (state is MainAuthError) {
                // Handle auth error state properly - show loading while navigating
                print(
                    'MainAuthError state - showing loading while navigating to login');
                return const Scaffold(body: LoadingMainScreen());
              }

              print(
                  'Fallback: Showing LoadingMainScreen for unknown state: ${state.runtimeType}');
              return const Scaffold(body: LoadingMainScreen());
            },
          ),
        );
      },
    );
  }
}
