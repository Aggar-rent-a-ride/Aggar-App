import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/loading_vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/loading_vehicle_type_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_type_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class MainScreenBody extends StatelessWidget {
  const MainScreenBody(
      {super.key, required this.state, required this.scrollController});
  final MainConnected state;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MainCubit>().refreshData();
      },
      child: SingleChildScrollView(
        controller: scrollController,
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
}
