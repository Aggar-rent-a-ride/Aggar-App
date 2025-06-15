// Modified search_result_section.dart with status count display

import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class SearchResultSection extends StatefulWidget {
  const SearchResultSection({super.key});

  @override
  _SearchResultSectionState createState() => _SearchResultSectionState();
}

class _SearchResultSectionState extends State<SearchResultSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 900 &&
          !(context.read<SearchCubit>().isLoadingMore) &&
          (context.read<SearchCubit>().state is SearchCubitLoaded &&
              (context.read<SearchCubit>().state as SearchCubitLoaded)
                  .canLoadMore)) {
        context.read<SearchCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchCubitState>(
      builder: (context, state) {
        final searchCubit = context.read<SearchCubit>();

        if (state is SearchCubitLoading) {
          return Center(
            child: SpinKitThreeBounce(
              color: context.theme.blue100_1,
              size: 30.0,
            ),
          );
        }

        if (state is SearchCubitError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 100, color: Colors.red),
                const Gap(16),
                Text(
                  state.message,
                  style:
                      AppStyles.medium16(context).copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                ElevatedButton(
                  onPressed: () => searchCubit.fetchSearch(pageNo: 1),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is SearchCubitLoaded) {
          final vehicles = state.vehicles.data;

          if (vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 100, color: Colors.grey),
                  const Gap(16),
                  Text(
                    'No vehicles found',
                    style: AppStyles.medium16(context)
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemCount: vehicles.length + (state.canLoadMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == vehicles.length && state.canLoadMore) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SpinKitThreeBounce(
                              color: context.theme.blue100_1,
                              size: 20.0,
                            ),
                          ),
                        );
                      }
                      final vehicle = vehicles[index];
                      return PopularVehiclesCarCard(
                        vehicleId: vehicle.id.toString(),
                        carName: "${vehicle.brand} ${vehicle.model}",
                        carType: vehicle.transmission,
                        pricePerHour: vehicle.pricePerDay,
                        rating: vehicle.rate,
                        assetImagePath: vehicle.mainImagePath,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_car_outlined,
                  size: 100, color: Colors.grey),
              const Gap(16),
              Text(
                'Search for vehicles',
                style: AppStyles.medium16(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
