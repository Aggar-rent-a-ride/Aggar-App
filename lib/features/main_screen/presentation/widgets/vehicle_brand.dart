import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget vehicleBrand(String imgPrv, String label) {
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
