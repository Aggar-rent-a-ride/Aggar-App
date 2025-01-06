import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/profile/data/car_model.dart';
import 'package:aggar/features/profile/data/profile_model.dart';
import 'package:aggar/features/profile/presentation/widgets/car_item_widget.dart';
import 'package:aggar/features/profile/presentation/widgets/profile_widget.dart';
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
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Profile Account"),
        actions: [
          IconButton(
            icon: const CustomIcon(
              hight: 32,
              width: 32,
              flag: false,
              imageIcon: AppAssets.assetsIconsMenu,
            ),
            onPressed: () {},
          ),
          const Gap(10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            ProfileWidget(profile: profile),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTabButton(0, 'Cars'),
                buildTabButton(1, 'Favorite'),
                buildTabButton(2, 'Statics'),
                buildTabButton(3, 'Reviews'),
              ],
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

  Widget buildTabButton(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color:
              selectedTabIndex == index ? AppColors.myBlue100_1 : Colors.white,
          border: Border.all(
              color: selectedTabIndex == index
                  ? AppColors.myBlue100_1
                  : AppColors.myGray100_1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: selectedTabIndex == index ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildCarsTab();
      case 1:
        return _buildFavoriteTab();
      case 2:
        return _buildStaticsTab();
      case 3:
        return _buildReviewsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCarsTab() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return CarItemWidget(car: cars[index]);
      },
    );
  }

  Widget _buildFavoriteTab() {
    return const Center(
      child: Text('Favorite Tab Content'),
    );
  }

  Widget _buildStaticsTab() {
    return const Center(
      child: Text('Statics Tab Content'),
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      children: const [
        ListTile(
          leading: CircleAvatar(child: Text('S')),
          title: Text('Scarlet Johnson'),
          subtitle: Text('Was a good deal, nice person but bad car, fix it!'),
        ),
        ListTile(
          leading: CircleAvatar(child: Text('N')),
          title: Text('Naruto Uzumaki'),
          subtitle: Text('Bad renter, tell him about the cat.'),
        ),
      ],
    );
  }
}
