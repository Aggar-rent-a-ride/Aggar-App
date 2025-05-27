import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_popular_vehicles_section.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/loading_vehicle_type_section.dart';
import 'package:aggar/features/main_screen/widgets/main_header.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoadingMainScreenBody extends StatelessWidget {
  const LoadingMainScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 55, bottom: 20),
            child: const MainHeader(
              accesstoken: "",
            ),
          ),
          const Gap(15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingVehicleTypeSection(),
                Gap(25),
                LoadingVehicleBrandSection(),
                Gap(30),
                LoadingPopularVehiclesSection(),
                Gap(25),
              ],
            ),
          )
        ],
      ),
    );
  }
}
