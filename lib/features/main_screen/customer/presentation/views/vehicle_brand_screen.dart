import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/brand_list.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/brand_more_list.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_type_brand_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class VehicleBrandScreen extends StatefulWidget {
  const VehicleBrandScreen({
    super.key,
    required this.selectedBrandId,
    required this.selectedBrandString,
  });

  final int selectedBrandId;
  final String selectedBrandString;

  @override
  _VehicleBrandScreenState createState() => _VehicleBrandScreenState();
}

class _VehicleBrandScreenState extends State<VehicleBrandScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _initializeTokenAndFetchVehicles();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !context.read<VehicleBrandCubit>().isLoadingMoreAll &&
          _accessToken != null) {
        context
            .read<VehicleBrandCubit>()
            .loadMoreVehicles(_accessToken!, widget.selectedBrandId);
      }
    });
  }

  Future<void> _initializeTokenAndFetchVehicles() async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.ensureValidToken();
    if (token != null) {
      setState(() {
        _accessToken = token;
      });
      await context
          .read<VehicleBrandCubit>()
          .fetchVehicleBrand(token, widget.selectedBrandId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          context,
          "Error",
          "Failed to retrieve access token",
          SnackBarType.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.blue100_8,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                  left: 20, right: 25, top: 50, bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: context.theme.white100_1,
                    ),
                  ),
                  const Gap(5),
                  Text(
                    widget.selectedBrandString,
                    style: AppStyles.bold20(context).copyWith(
                      color: context.theme.white100_1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<VehicleBrandCubit, VehicleBrandState>(
            builder: (context, state) {
              if (state is VehicleBrandLoading) {
                return const SliverToBoxAdapter(
                    child: LoadingTypeBrandScreen());
              } else if (state is VehicleLoadedBrand) {
                if (state.vehicles == null || state.vehicles!.data.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 64,
                            color: context.theme.black100.withOpacity(0.6),
                          ),
                          const Gap(15),
                          Text(
                            'No vehicles yet!',
                            style: AppStyles.regular16(context).copyWith(
                              color: context.theme.black100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(child: BrandList(state: state));
              } else if (state is VehicleBrandLoadingMore &&
                  state.vehicles != null) {
                return SliverToBoxAdapter(child: BrandMoreList(state: state));
              } else if (state is VehicleBrandError) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message,
                          style: AppStyles.regular16(context).copyWith(
                            color: context.theme.black100,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _accessToken != null
                              ? () => context
                                  .read<VehicleBrandCubit>()
                                  .fetchVehicleBrand(
                                      _accessToken!, widget.selectedBrandId)
                              : _initializeTokenAndFetchVehicles,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No data available')),
              );
            },
          ),
        ],
      ),
    );
  }
}
