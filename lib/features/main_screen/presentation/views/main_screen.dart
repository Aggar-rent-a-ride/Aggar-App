import 'dart:async';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_dialog.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/adding_vehicle_floating_action_button.dart';
import 'package:aggar/features/main_screen/presentation/widgets/loading_main_screen.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final vehicleCubit = context.read<VehicleCubit>();
    final mainCubit = context.read<MainCubit>();
    scrollController.addListener(() {
      if (_debounce?.isActive ?? false) return;
      _debounce = Timer(const Duration(milliseconds: 200), () {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !vehicleCubit.isLoadingMore) {
          final mainState = mainCubit.state;
          if (mainState is MainConnected) {
            vehicleCubit.loadMoreVehicles(mainState.accessToken);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        if (state is MainAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
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
                  SnackBar(content: Text(vehicleState.message)),
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
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.startFloat,
                  floatingActionButton:
                      const AddingVehicleFloatingActionButton(),
                  backgroundColor: context.theme.white100_1,
                  body: MainScreenBody(
                    state: state,
                    scrollController: scrollController,
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
