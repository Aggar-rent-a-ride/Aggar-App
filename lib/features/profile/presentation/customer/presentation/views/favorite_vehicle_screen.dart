import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../main_screen/customer/presentation/widgets/loading_all_vehicle.dart';
import '../cubit/profile/profile_cubit.dart';
import '../cubit/profile/profile_state.dart';

class FavoriteVehicleScreen extends StatefulWidget {
  const FavoriteVehicleScreen({super.key});

  @override
  State<FavoriteVehicleScreen> createState() => _FavoriteVehicleScreenState();
}

class _FavoriteVehicleScreenState extends State<FavoriteVehicleScreen> {
  late ScrollController _scrollController;
  late ProfileCubit _cubit;
  String? tokenr;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _cubit = context.read<ProfileCubit>();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.ensureValidToken();
    if (token != null) {
      setState(() {
        tokenr = token;
      });
      _cubit.fetchFavoriteVehicles(token);
    }
  }

  void _onScroll() {
    if (_isBottom && tokenr != null) {
      _cubit.loadMoreFavoriteVehicles(tokenr!);
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
    return Scaffold(
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
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 55, bottom: 8),
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
                  "All Favorite Vehicles",
                  style: AppStyles.bold20(context).copyWith(
                    color: context.theme.white100_1,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Error",
                      "Vehicle Error: ${state.errorMessage}",
                      SnackBarType.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: LoadingAllVehicle(),
                  );
                }
                if (state is ProfileGetFavoriteSuccess ||
                    state is ProfileFavoriteVehicleLoadingMore) {
                  final vehicles = _cubit.favoriteVehicles;
                  final canLoadMore = _cubit.canLoadMoreFavorite;
                  final isLoadingMore =
                      state is ProfileFavoriteVehicleLoadingMore;
                  return Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            controller: _scrollController,
                            itemCount: vehicles.length +
                                (canLoadMore || isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == vehicles.length) {
                                if (isLoadingMore) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: context.theme.blue100_8,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                              final vehicle = vehicles[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: PopularVehiclesCarCard(
                                  assetImagePath: vehicle.mainImagePath,
                                  carName: "${vehicle.brand} ${vehicle.model}",
                                  carType: vehicle.transmission,
                                  pricePerHour: vehicle.pricePerDay,
                                  vehicleId: vehicle.id.toString(),
                                  rating: vehicle.rate,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: LoadingAllVehicle());
              },
            ),
          ),
        ],
      ),
    );
  }
}
