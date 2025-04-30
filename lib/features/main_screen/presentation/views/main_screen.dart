import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/adding_vehicle_floating_action_button.dart';
import 'package:aggar/features/main_screen/presentation/widgets/loading_main_screen.dart';
import 'package:aggar/features/main_screen/presentation/widgets/loading_vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/loading_vehicle_type_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_type_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
          _showNoNetworkDialog(context);
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
          child: _buildScreenBasedOnState(context, state),
        );
      },
    );
  }

  Widget _buildScreenBasedOnState(BuildContext context, MainState state) {
    if (state is MainLoading || state is MainInitial) {
      return const Scaffold(body: LoadingMainScreen());
    } else if (state is MainDisconnected) {
      return Scaffold(
        backgroundColor: context.theme.white100_1,
        body: const LoadingMainScreen(),
      );
    } else if (state is MainConnected) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: const AddingVehicleFloatingActionButton(),
        backgroundColor: context.theme.white100_1,
        body: _buildMainContent(context, state),
      );
    }
    return const Scaffold(body: LoadingMainScreen());
  }

  Widget _buildMainContent(BuildContext context, MainConnected state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MainCubit>().refreshData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.blue100_8,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 55, bottom: 20),
              child: const MainHeader(),
            ),
            const Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.isVehicleTypesLoaded
                      ? const VehiclesTypeSection()
                      : Shimmer.fromColors(
                          baseColor: context.theme.gray100_1,
                          highlightColor: context.theme.white100_1,
                          child: const LoadingVehicleTypeSection(),
                        ),
                  state.isVehicleBrandsLoaded
                      ? const BrandsSection()
                      : Shimmer.fromColors(
                          baseColor: context.theme.gray100_1,
                          highlightColor: context.theme.white100_1,
                          child: const LoadingVehicleBrandSection(),
                        ),
                  const PopularVehiclesSection(),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showNoNetworkDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
            'Please check your internet connection and try again.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<MainCubit>().checkInternetConnection();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Exit App'),
            ),
          ],
        );
      },
    );
  }
}
