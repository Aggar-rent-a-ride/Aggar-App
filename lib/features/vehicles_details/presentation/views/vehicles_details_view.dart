import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/booking/presentation/views/booking_view.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/bottom_navigation_bar_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/car_name_with_type_and_year_of_manifiction.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/tab_bar_section.dart';
import 'package:flutter/material.dart';

class VehiclesDetailsView extends StatelessWidget {
  const VehiclesDetailsView({
    super.key,
    required this.vehicleId,
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
  
  final String vehicleId; // Add this line
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
          elevation: 1,
          shadowColor: Colors.grey[900],
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: context.theme.white100_1,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
              ),
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.theme.black100,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Vehicle Details',
            style: AppStyles.semiBold24(context)
                .copyWith(color: context.theme.black100),
          ),
        ),
        backgroundColor: context.theme.white100_1,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  spacing: 10,
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
                    TabBarSection(
                      vehilceType: vehicleType,
                      pfpImage: pfpImage,
                      renterName: renterName,
                      vehicleColor: vehicleColor,
                      vehicleOverView: vehicleOverView,
                      vehiceSeatsNo: vehiceSeatsNo,
                      images: images,
                      mainImage: mainImage,
                      vehicleHealth: vehicleHealth,
                      vehicleStatus: vehicleStatus,
                      vehicleAddress: vehicleAddress,
                      vehicleLongitude: vehicleLongitude,
                      vehicleLatitude: vehicleLatitude,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarSection(
          price: vehicleRentPrice, 
          onPressed: () {
            // Navigate to BookVehicleScreen with vehicleId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookVehicleScreen(
                  vehicleId: vehicleId,
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}