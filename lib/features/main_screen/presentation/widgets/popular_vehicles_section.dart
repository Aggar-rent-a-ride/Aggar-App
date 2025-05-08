import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicles/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_styles.dart';
import 'popular_vehicles_car_card.dart';

class PopularVehiclesSection extends StatelessWidget {
  const PopularVehiclesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Popular vehicles',
              style: AppStyles.bold24(context).copyWith(
                color: context.theme.blue100_5,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    'see all',
                    style: AppStyles.medium15(context).copyWith(
                      color: context.theme.blue100_2,
                    ),
                  ),
                  const Gap(5),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: context.theme.blue100_2,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(5),
        const VehicleList()
      ],
    );
  }
}

class VehicleList extends StatelessWidget {
  const VehicleList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        if (state is VehicleLoaded) {
          return Column(
            children: List.generate(
              state.vehicles.data.length,
              (index) => PopularVehiclesCarCard(
                carName: state.vehicles.data[index].brand,
                carType: state.vehicles.data[index].type,
                pricePerHour: state.vehicles.data[index].pricePerDay,
                rating: 4.8,
                assetImagePath: state.vehicles.data[index].mainImagePath,
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
                3,
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
    );
  }
}
