import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SelectedLocationSection extends StatelessWidget {
  const SelectedLocationSection(
      {super.key, required this.isLoading, required this.address});
  final bool isLoading;
  final String address;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.2,
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: AppColors.myWhite100_1,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.myBlack25,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.myBlue100_1,
                  size: 24,
                ),
                // not finish
                Text(
                  maxLines: 5,
                  address.substring(1, 5),
                  style: AppStyles.bold24(context)
                      .copyWith(color: AppColors.myBlue100_1),
                ),
              ],
            ),
            Text(
              address,
              style: AppStyles.semiBold16(context).copyWith(
                color: AppColors.myBlack50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
