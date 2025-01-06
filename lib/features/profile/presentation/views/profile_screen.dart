import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/profile/data/car_model.dart';
import 'package:aggar/features/profile/data/profile_model.dart';
import 'package:aggar/features/profile/presentation/widgets/car_item_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatelessWidget {
  final Profile profile = Profile(
    name: "Adele Famous",
    role: "Renter",
    avatarAsset: AppAssets.assetsImagesProfile,
    description: "Some information about the renter...",
  );

  final List<Car> cars = [
    Car(
        name: "Tesla Model S",
        pricePerHour: 120,
        rating: 4.8,
        distance: 450,
        assetImage: AppAssets.assetsImagesCar),
    Car(
        name: "Tesla Model X",
        pricePerHour: 150,
        rating: 4.9,
        distance: 500,
        assetImage: AppAssets.assetsImagesCar),
  ];

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile Account"),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileWidget(profile: profile),
            const Gap(20),
            ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              isSelected: const [true, false, false, false],
              onPressed: (index) {},
              renderBorder: false,
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              constraints: const BoxConstraints(
                minHeight: 40,
                minWidth: 80,
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Cars"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Favorite"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Statics"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Reviews"),
                ),
              ],
            ),
            const Gap(20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                return CarItemWidget(car: cars[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
