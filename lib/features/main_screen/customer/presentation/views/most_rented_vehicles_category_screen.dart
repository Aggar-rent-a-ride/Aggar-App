import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/all_vehicle_error.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_all_vehicle.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/most_rented_vehicles_body.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/no_vehilce_found_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MostRentedVehiclesCategoryScreen extends StatefulWidget {
  final String accessToken;

  const MostRentedVehiclesCategoryScreen(
      {required this.accessToken, super.key});

  @override
  State<MostRentedVehiclesCategoryScreen> createState() =>
      _MostRentedVehiclesCategoryScreenState();
}

class _MostRentedVehiclesCategoryScreenState
    extends State<MostRentedVehiclesCategoryScreen> {
  late ScrollController _scrollController;
  VehicleCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && _cubit != null) {
      _cubit!.loadMoreMostRentedVehicles(widget.accessToken);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _cubit = VehicleCubit()..fetchMostRentedVehicles(widget.accessToken);
        return _cubit!;
      },
      child: Scaffold(
        backgroundColor: context.theme.white100_1,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.blue100_8,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 55, bottom: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: context.theme.white100_1,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Most Rented Vehicles",
                    style: AppStyles.bold20(context).copyWith(
                      color: context.theme.white100_1,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<VehicleCubit, VehicleState>(
                listener: (context, state) {
                  if (state is VehicleError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackBar(
                        context,
                        "Error",
                        "Vehicle Error: ${state.message}",
                        SnackBarType.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<VehicleCubit>();

                  if (state is VehicleLoading) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      child: LoadingAllVehicle(),
                    );
                  }

                  if (state is VehicleLoaded || state is VehicleLoadingMore) {
                    final vehicles = cubit.mostRentedVehicles;
                    final canLoadMore = cubit.canLoadMoreMostRented;
                    final isLoadingMore = state is VehicleLoadingMore;

                    if (vehicles.isEmpty) {
                      return NoVehilceFoundBody(cubit: cubit);
                    }

                    return MostRentedVehiclesBody(
                        cubit: cubit,
                        widget: widget,
                        scrollController: _scrollController,
                        vehicles: vehicles,
                        canLoadMore: canLoadMore,
                        isLoadingMore: isLoadingMore);
                  }

                  if (state is VehicleError) {
                    return AllVehicleError(cubit: cubit);
                  }

                  return const Center(child: LoadingAllVehicle());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
