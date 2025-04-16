import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/gallary_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/over_view_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/bottom_navigation_bar_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/car_name_with_type_and_year_of_manifiction.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VehicleDetailsAfterAddingScreen extends StatelessWidget {
  const VehicleDetailsAfterAddingScreen({
    super.key,
    required this.yearOfManufaction,
    required this.vehicleModel,
    required this.vehicleRentPrice,
    required this.vehicleColor,
    required this.vehicleOverView,
    required this.vehiceSeatsNo,
    required this.images,
    required this.mainImage,
    required this.vehicleHealth,
    required this.vehicleStatus,
    required this.transmissionMode,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleAddress,
    required this.vehicleLongitude,
    required this.vehicleLatitude,
    this.pfpImage,
    required this.renterName,
  });
  final int yearOfManufaction;
  final String vehicleModel;
  final double vehicleRentPrice;
  final String vehicleColor;
  final String vehicleOverView;
  final String vehiceSeatsNo;
  final List<String?> images;
  final String mainImage;
  final String vehicleHealth;
  final String vehicleStatus;
  final int transmissionMode;
  final String vehicleType;
  final String vehicleBrand;
  final String vehicleAddress;
  final double vehicleLongitude;
  final double vehicleLatitude;
  final String? pfpImage;
  final String renterName;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppLightColors.myWhite100_1,
          actions: [
            IconButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 25),
                ),
              ),
              icon: Icon(
                Icons.favorite_border,
                color: AppLightColors.myBlack100,
              ),
              onPressed: () {},
            ),
          ],
          centerTitle: true,
          title: Text(
            "Vehicles Details",
            style: AppStyles.semiBold24(context).copyWith(
              color: AppLightColors.myBlack100,
            ),
          ),
          leading: IconButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 25),
              ),
            ),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppLightColors.myBlack100,
            ),
            onPressed: () {},
          ),
        ),
        backgroundColor: AppLightColors.myWhite100_1,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageCar(
                  mainImage: mainImage,
                ),
                CarNameWithTypeAndYearOfManifiction(
                  carName: '$vehicleBrand $vehicleModel',
                  manifactionYear: yearOfManufaction,
                  transmissionType: transmissionMode,
                ),
                GallarySection(
                  images: images,
                  mainImage: mainImage,
                  style: AppStyles.bold18(context).copyWith(
                    color: AppLightColors.myBlue100_2,
                  ),
                ),
                OverViewSection(
                  style: AppStyles.bold18(context).copyWith(
                    color: AppLightColors.myBlue100_2,
                  ),
                  vehicleType: vehicleType,
                  color: vehicleColor,
                  seatsno: vehiceSeatsNo,
                  overviewText: vehicleOverView,
                  carHealth: vehicleHealth,
                  carStatus: vehicleStatus,
                ),
              ],
            ),
          ),
        ),
        // TODO :what to edit with edit button
        bottomNavigationBar: BottomNavigationBarSection(
            price: vehicleRentPrice, onPressed: () {}),
      ),
    );
  }
}
