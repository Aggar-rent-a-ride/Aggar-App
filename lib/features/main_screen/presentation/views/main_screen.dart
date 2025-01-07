import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF243B55),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          CustomIcon(
                            hight: 25,
                            width: 25,
                            flag: false,
                            imageIcon: AppAssets.assetsIconsLocation,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "Minya al-Qamh, Sharkia, Egypt",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.myBlue100_4,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CustomIcon(
                                hight: 0,
                                width: 0,
                                flag: false,
                                imageIcon: AppAssets.assetsIconsNotification,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 9,
                            top: 9,
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                color: AppColors.myGreen100_1,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.myBlue100_4,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const CustomIcon(
                              hight: 20,
                              width: 20,
                              flag: false,
                              imageIcon: AppAssets.assetsIconsSort,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vehicles Type",
                    style: TextStyle(
                      color: AppColors.myBlue100_1,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _vehicleTypeIcon(AppAssets.assetsIconsCarIcon, "Cars"),
                        _vehicleTypeIcon(
                            AppAssets.assetsIconsTruckIcon, "Trucks"),
                        _vehicleTypeIcon(AppAssets.assetsIconsMotorcyclesIcon,
                            "Motorcycles"),
                        _vehicleTypeIcon(AppAssets.assetsIconsRecreationalIcon,
                            "Recreational"),
                      ],
                    ),
                  ),
                  const Gap(20),
                  Text(
                    "Brands",
                    style: TextStyle(
                      color: AppColors.myBlue100_1,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
                        _vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
                        _vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
                        _vehicleBrand(AppAssets.assetsImagesTesla, "Tesla"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleTypeIcon(String iconPrv, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.myWhite100_3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              CustomIcon(
                hight: 35,
                width: 35,
                flag: false,
                imageIcon: iconPrv,
              ),
              const Gap(10),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleBrand(String imgPrv, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.myWhite100_3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            children: [
              CustomIcon(
                hight: 90,
                width: 90,
                flag: false,
                imageIcon: imgPrv,
              ),
              const Gap(10),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
