import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class VehicleBrandScreen extends StatelessWidget {
  const VehicleBrandScreen({super.key, required this.selectedBrand});
  final String selectedBrand;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        title: Text(
          selectedBrand,
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
      ),
      backgroundColor: context.theme.white100_1,
      body: BlocBuilder<VehicleBrandCubit, VehicleBrandState>(
        builder: (context, state) {
          if (state is VehicleLoadedBrand && state.vehicles != null) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Column(
                  children: List.generate(
                    state.vehicles!.data.length,
                    (index) => PopularVehiclesCarCard(
                      vehicleId: state.vehicles!.data[index].id.toString(),
                      carName:
                          "${state.vehicles!.data[index].brand} ${state.vehicles!.data[index].model}",
                      carType: state.vehicles!.data[index].type,
                      pricePerHour: state.vehicles!.data[index].pricePerDay,
                      rating: 4.8,
                      assetImagePath: state.vehicles!.data[index].mainImagePath,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: context.theme.gray100_1,
              highlightColor: context.theme.white100_1,
              child: Column(
                spacing: 15,
                children: List.generate(
                  10,
                  (index) => Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: context.theme.white100_1,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
