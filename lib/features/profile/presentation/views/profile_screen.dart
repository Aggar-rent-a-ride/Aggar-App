import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/profile/data/car_model.dart';
import 'package:aggar/features/profile/data/profile_model.dart';
import 'package:aggar/features/profile/presentation/widgets/profile_tabs.dart';
import 'package:aggar/features/profile/presentation/widgets/profile_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final Profile profile = Profile(
    name: "Adele Famous",
    role: "Renter",
    avatarAsset: AppAssets.assetsImagesProfile,
    description:
        "renter and should be different from the user or not? i don’t know lets ask the backend? well no need i already know the answer but it just words :)",
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
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Profile Account",
          style: AppStyles.bold24(context),
        ),
        actions: [
          IconButton(
            icon: const CustomIcon(
              hight: 30,
              width: 30,
              flag: false,
              imageIcon: AppAssets.assetsIconsMenu,
            ),
            onPressed: () {},
          ),
          const Gap(25)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        child: Column(
          children: [
            ProfileWidget(profile: profile),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return TabButton(
                  index: index,
                  title: ['Cars', 'Favorite', 'Statics', 'Reviews'][index],
                  selectedIndex: selectedTabIndex,
                  onTabSelected: (i) {
                    setState(() {
                      selectedTabIndex = i;
                    });
                  },
                );
              }),
            ),
            const Divider(
              indent: 7,
              endIndent: 7,
            ),
            Expanded(
              child: buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return const CarsTab();
      case 1:
        return const FavoriteTab();
      case 2:
        return const StaticsTab();
      case 3:
        return const ReviewsTab();
      default:
        return const SizedBox.shrink();
    }
  }
}
