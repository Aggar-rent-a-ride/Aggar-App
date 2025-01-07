import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/profile/data/car_model.dart';
import 'package:flutter/material.dart';

class CarItemWidget extends StatelessWidget {
  final Car car;

  const CarItemWidget({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                car.assetImage,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomIcon(
                          hight: 15,
                          width: 15,
                          flag: false,
                          imageIcon: AppAssets.assetsIconsStar,
                        ),
                        Text(" ${car.rating.toString()}"),
                      ],
                    ),
                    Row(children: [
                      const CustomIcon(
                        hight: 12,
                        width: 12,
                        flag: false,
                        imageIcon: AppAssets.assetsIconsMap,
                      ),
                      Text(
                        " ${car.distance} km",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  car.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "\$${car.pricePerHour}",
                      style:
                          TextStyle(fontSize: 18, color: AppColors.myBlue100_2),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "/hr",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.myBlue100_2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
