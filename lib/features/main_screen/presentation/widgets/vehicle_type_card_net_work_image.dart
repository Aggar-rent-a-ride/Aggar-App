import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VehicleTypeCardNetWorkImage extends StatelessWidget {
  const VehicleTypeCardNetWorkImage(
      {super.key, required this.iconPrv, required this.label});
  final String iconPrv;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
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
        child: Row(
          children: [
            iconPrv == "null"
                ? const SizedBox()
                : SizedBox(
                    height: 35,
                    width: 35,
                    child: Image.network(
                      "${EndPoint.baseUrl}$iconPrv",
                    ),
                  ),
            const Gap(10),
            Text(
              label,
              style: AppStyles.medium12(context),
            ),
          ],
        ),
      ),
    );
  }
}
