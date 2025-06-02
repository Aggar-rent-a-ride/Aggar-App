import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BookingSummaryCard extends StatelessWidget {
  final String vehicleName;
  final String pricePerDay;
  final String ownerName;
  final String ownerRole;
  final String ownerImageUrl;

  const BookingSummaryCard({
    super.key,
    required this.vehicleName,
    required this.pricePerDay,
    required this.ownerName,
    required this.ownerRole,
    required this.ownerImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.myBlue100_1.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: AppStyles.semiBold16(context).copyWith(
              color: AppConstants.myBlack100_1,
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleName,
                      style: AppStyles.regular14(context).copyWith(
                        color: AppConstants.myBlue100_4,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      pricePerDay,
                      style: AppStyles.bold16(context).copyWith(
                        color: AppConstants.myBlue100_3,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppConstants.myBlue100_4,
                    backgroundImage: NetworkImage(ownerImageUrl),
                  ),
                  const Gap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ownerName,
                        style: AppStyles.semiBold14(context).copyWith(
                          color: AppConstants.myBlack100_1,
                        ),
                      ),
                      Text(
                        ownerRole,
                        style: AppStyles.regular12(context).copyWith(
                          color: AppConstants.myBlue100_4,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
