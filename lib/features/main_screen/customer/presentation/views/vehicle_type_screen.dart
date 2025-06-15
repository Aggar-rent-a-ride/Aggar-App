import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_type_brand_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/type_list.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/type_more_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class VehicleTypeScreen extends StatefulWidget {
  const VehicleTypeScreen({
    super.key,
    required this.selectedTypeId,
    required this.selectedTypeString,
  });

  final int selectedTypeId;
  final String selectedTypeString;

  @override
  _VehicleTypeScreenState createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _initializeTokenAndFetchVehicles();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !context.read<VehicleTypeCubit>().isLoadingMoreAll &&
          _accessToken != null) {
        context
            .read<VehicleTypeCubit>()
            .loadMoreVehicles(_accessToken!, widget.selectedTypeId);
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
          .read<VehicleTypeCubit>()
          .fetchVehicleType(token, widget.selectedTypeId);
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
                    left: 20, right: 25, top: 50, bottom: 16),
                child: Row(
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
                      widget.selectedTypeString,
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
              child: BlocBuilder<VehicleTypeCubit, VehicleTypeState>(
                builder: (context, state) {
                  if (state is VehicleTypeLoading) {
                    return const LoadingTypeBrandScreen();
                  } else if (state is VehicleLoadedType &&
                      state.vehicles != null) {
                    return TypeList(state: state);
                  } else if (state is VehicleTypeLoadingMore &&
                      state.vehicles != null) {
                    return TypeMoreList(state: state);
                  } else if (state is VehicleTypeError) {
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
                                    .read<VehicleTypeCubit>()
                                    .fetchVehicleType(
                                        _accessToken!, widget.selectedTypeId)
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
