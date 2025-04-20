import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicles_brand_number_of_brands.dart';
import 'package:flutter/material.dart';

class VehicleBrandCardNetWorkImage extends StatelessWidget {
  const VehicleBrandCardNetWorkImage(
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
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: context.theme.black25,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            imgPrv == "null"
                ? const SizedBox(
                    height: 80,
                    width: 80,
                  )
                : SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.network(
                      "${EndPoint.baseUrl}$imgPrv",
                    ),
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
