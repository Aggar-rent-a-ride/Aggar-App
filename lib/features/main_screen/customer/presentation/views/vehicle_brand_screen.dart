import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/brand_list.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/brand_more_list.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_type_brand_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final token = await tokenCubit.getAccessToken();
    if (token != null) {
      setState(() {
        _accessToken = token;
      });
      await context
          .read<VehicleBrandCubit>()
          .fetchVehicleBrand(token, widget.selectedBrandId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to retrieve access token')),
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
      body: RefreshIndicator(
        onRefresh: _initializeTokenAndFetchVehicles,
        child: CustomScrollView(
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
                    left: 25, right: 25, top: 65, bottom: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    Text(
                      widget.selectedBrandString,
                      style: AppStyles.bold20(context).copyWith(
                        color: context.theme.white100_1,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<VehicleBrandCubit, VehicleBrandState>(
                builder: (context, state) {
                  if (state is VehicleBrandLoading) {
                    return const LoadingTypeBrandScreen();
                  } else if (state is VehicleLoadedBrand &&
                      state.vehicles != null) {
                    return BrandList(state: state);
                  } else if (state is VehicleBrandLoadingMore &&
                      state.vehicles != null) {
                    return BrandMoreList(state: state);
                  } else if (state is VehicleBrandError) {
                    return Center(
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
                    );
                  }
                  return const Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
