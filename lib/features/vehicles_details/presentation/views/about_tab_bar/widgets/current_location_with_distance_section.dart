import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart' show AppStyles;
import 'package:flutter/material.dart';

class CurrentLocationWithDistanceSection extends StatelessWidget {
  const CurrentLocationWithDistanceSection({
    super.key,
    required this.vehicleAddress,
  });
  final String vehicleAddress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_sharp,
            size: 20,
            color: AppColors.myGray100_2,
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                overflow: TextOverflow.ellipsis,
                vehicleAddress,
                style: AppStyles.semiBold16(context).copyWith(
                  color: AppColors.myBlack50,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "1.4km",
              style: AppStyles.semiBold16(context).copyWith(
                color: AppColors.myBlack50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
