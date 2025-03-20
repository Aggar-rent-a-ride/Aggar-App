import 'package:aggar/core/themes/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_brand_number_of_brands.dart';
import 'package:flutter/material.dart';

class VehicleBrandCard extends StatelessWidget {
  const VehicleBrandCard(
      {super.key,
      required this.imgPrv,
      required this.label,
      required this.numOfBrands});
  final String imgPrv;
  final String label;
  final int numOfBrands;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      width: MediaQuery.of(context).size.width * 0.27,
      decoration: BoxDecoration(
        color: AppLightColors.myWhite100_2,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: AppLightColors.myBlack25,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            CustomIcon(
              hight: 80,
              width: 80,
              flag: false,
              imageIcon: imgPrv,
            ),
            Row(
              children: [
                Text(
                  label,
                  style: AppStyles.bold10(context),
                ),
                const Spacer(),
                VehiclesBrandNumberOfBrands(numOfBrands: numOfBrands)
              ],
            )
          ],
        ),
      ),
    );
  }
}
