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
import 'package:aggar/core/services/signalr_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Future<void> _startSignalR() async {
    const secureStorage = FlutterSecureStorage();
    String? userIdStr = await secureStorage.read(key: 'userId');
    int? userId = userIdStr != null ? int.tryParse(userIdStr) : null;
    if (userId != null && userId > 0) {
      await SignalRService().initialize(userId: userId);
      print('SignalRService initialized for customer with userId: $userId');
    } else {
      print('SignalRService not started: userId not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSignalR();
    });
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is MainAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Auth Error: ${state.message}",
              SnackBarType.error,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInView()),
          );
        } else if (state is MainDisconnected) {
          showNoNetworkDialog(context);
        }
      },
      builder: (context, state) {
        return BlocListener<TokenRefreshCubit, TokenRefreshState>(
          listener: (context, tokenState) {
            if (tokenState is TokenRefreshSuccess) {
              context
                  .read<MainCubit>()
                  .handleTokenRefreshSuccess(tokenState.accessToken);
            } else if (tokenState is TokenRefreshFailure) {
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
              if (state is MainLoading || state is MainInitial) {
                return const Scaffold(body: LoadingMainScreen());
              } else if (state is MainDisconnected) {
                return Scaffold(
                  backgroundColor: context.theme.white100_1,
                  body: const LoadingMainScreen(),
                );
              } else if (state is MainConnected) {
                return Scaffold(
                  backgroundColor: context.theme.white100_1,
                  body: MainScreenBody(
                    state: state,
                  ),
                );
              }
              return const Scaffold(body: LoadingMainScreen());
            },
          ),
        );
      },
    );
  }
}
