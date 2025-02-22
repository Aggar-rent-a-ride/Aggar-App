import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/book_vehicle_button.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/car_name_with_type_and_year_of_manifiction.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_image_car.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/tab_bar_section.dart';
import 'package:flutter/material.dart';

class VehiclesDetailsView extends StatelessWidget {
  const VehiclesDetailsView({super.key});

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
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageCar(),
                    CarNameWithTypeAndYearOfManifiction(
                      carName: 'Lamborghini Sesto Elemento ',
                      manifactionYear: 1989,
                      transmissionType: 'Automatic',
                    ),
                    TabBarSection(),
                  ],
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BookVehicleButton(),
      ),
    );
  }
}
