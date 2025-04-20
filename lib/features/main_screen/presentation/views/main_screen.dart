import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/widgets/adding_vehicle_floating_action_button.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/main_header.dart';
import 'package:aggar/features/main_screen/presentation/widgets/popular_vehicles_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_type_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: const AddingVehicleFloatingActionButton(),
      backgroundColor: context.theme.white100_1,
      body: SingleChildScrollView(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VehiclesTypeSection(),
                  Gap(10),
                  BrandsSection(),
                  Gap(10),
                  PopularVehiclesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
