import 'package:aggar/core/themes/app_colors.dart';
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
          color: AppLightColors.myWhite100_1,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppLightColors.myBlack25,
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
                  color: AppLightColors.myBlue100_1,
                  size: 24,
                ),
                Text(
                  maxLines: 5,
                  address.split(',').last.trim(),
                  style: AppStyles.bold24(context)
                      .copyWith(color: AppLightColors.myBlue100_1),
                ),
              ],
            ),
            Text(
              address,
              style: AppStyles.semiBold16(context).copyWith(
                color: AppLightColors.myBlack50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
