import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                car.assetImage,
                width: double.infinity,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CustomIcon(
                          hight: 12,
                          width: 12,
                          flag: false,
                          imageIcon: AppAssets.assetsIconsStar,
                        ),
                        Text(" ${car.rating.toString()}",
                            style: AppStyles.semiBold12(context)),
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
                        style: AppStyles.bold12(context)
                            .copyWith(color: Colors.grey),
                      ),
                    ]),
                  ],
                ),
                Text(car.name, style: AppStyles.semiBold20(context)),
                Row(
                  children: [
                    Text(
                      "\$${car.pricePerHour}",
                      style: AppStyles.regular24(context)
                          .copyWith(color: AppColors.myBlue100_2),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "/hr",
                        style: AppStyles.regular12(context)
                            .copyWith(color: AppColors.myBlue100_2),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        fixedSize: const Size(60, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: AppColors.myBlue100_2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                      ),
                      child: Text(
                        "Show more",
                        style: AppStyles.regular12(context)
                            .copyWith(color: AppColors.myBlue100_2),
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
