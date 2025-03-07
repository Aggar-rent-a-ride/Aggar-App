import 'dart:io';

import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/bottom_navigation_bar_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/car_name_with_type_and_year_of_manifiction.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/tab_bar_section.dart';
import 'package:flutter/material.dart';

class VehiclesDetailsView extends StatelessWidget {
  const VehiclesDetailsView(
      {super.key,
      required this.yearOfManufaction,
      required this.vehicleModel,
      required this.vehicleRentPrice,
      required this.vehicleColor,
      required this.vehicleOverView,
      required this.vehiceSeatsNo,
      required this.images});
  final int yearOfManufaction;
  final String vehicleModel;
  final double vehicleRentPrice;
  final String vehicleColor;
  final String vehicleOverView;
  final String vehiceSeatsNo;
  final List<File?> images;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.myWhite100_1,
          actions: [
            IconButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 25),
                ),
              ),
              icon: Icon(
                Icons.favorite_border,
                color: AppColors.myBlack100,
              ),
              onPressed: () {},
            ),
          ],
          centerTitle: true,
          title: Text("Vehicles Details",
              style: AppStyles.semiBold24(context)
                  .copyWith(color: AppColors.myBlack100)),
          leading: IconButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 25),
              ),
            ),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.myBlack100,
            ),
            onPressed: () {},
          ),
        ),
        backgroundColor: AppColors.myWhite100_1,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          // TODO: sub screens with no space
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomImageCar(),
                    CarNameWithTypeAndYearOfManifiction(
                      carName: 'Lamborghini Sesto Elemento $vehicleModel',
                      manifactionYear: yearOfManufaction,
                      transmissionType: 'Automatic',
                    ),
                    TabBarSection(
                      vehicleColor: vehicleColor,
                      vehicleOverView: vehicleOverView,
                      vehiceSeatsNo: vehiceSeatsNo,
                      images: images,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarSection(
            price: vehicleRentPrice, onPressed: () {}),
      ),
    );
  }
}
