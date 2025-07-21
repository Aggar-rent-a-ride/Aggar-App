import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/widgets/pricing_and_discounts_section.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/widgets/vehicle_details_menu_icon_button.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/widgets/vehicle_review_list.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/location_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/gallary_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/properities_tab_bar/widgets/over_view_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/review_tab_bar/widgets/rating_and_reviews_section.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/car_name_with_type_and_year_of_manifiction.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
    required this.vehicleId,
    this.vehicleRate,
    this.discountList,
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
  final String vehicleId;
  final double? vehicleRate;
  final List<dynamic>? discountList;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.theme.white100_1,
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.grey[900],
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: context.theme.white100_1,
          actions: [VehicleDetailsMenuIconButton(vehicleId: vehicleId)],
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
            style: AppStyles.semiBold24(
              context,
            ).copyWith(color: context.theme.black100),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(5),
                CustomImageCar(mainImage: mainImage),
                CarNameWithTypeAndYearOfManifiction(
                  carName: '$vehicleBrand $vehicleModel',
                  manifactionYear: yearOfManufaction,
                  transmissionType: transmissionMode,
                ),
                GallarySection(
                  images: images,
                  mainImage: mainImage,
                  style: AppStyles.bold18(
                    context,
                  ).copyWith(color: context.theme.blue100_2),
                ),
                OverViewSection(
                  style: AppStyles.bold18(
                    context,
                  ).copyWith(color: context.theme.blue100_2),
                  vehicleType: vehicleType,
                  color: vehicleColor,
                  seatsno: vehiceSeatsNo,
                  overviewText: vehicleOverView,
                  carHealth: vehicleHealth,
                  carStatus: vehicleStatus,
                ),
                LocationSection(
                  vehicleAddress: vehicleAddress,
                  vehicleLongitude: vehicleLongitude,
                  vehicleLatitude: vehicleLatitude,
                  style: AppStyles.bold18(
                    context,
                  ).copyWith(color: context.theme.blue100_2),
                ),
                RatingAndReviewsSection(
                  vehicleRate: vehicleRate,
                  style: AppStyles.bold18(
                    context,
                  ).copyWith(color: context.theme.blue100_2),
                ),
                VehicleReviewList(vehicleId: vehicleId),
                PricingAndDiscountsSection(
                  discountList: discountList ?? [],
                  price: vehicleRentPrice,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
