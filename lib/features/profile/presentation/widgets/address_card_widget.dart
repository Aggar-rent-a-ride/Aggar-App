import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddressCardWidget extends StatelessWidget {
  const AddressCardWidget({
    super.key,
    required this.addressComponents,
  });

  final Map<String, String?> addressComponents;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.theme.blue100_1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color: context.theme.white100_1,
                  size: 24,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  addressComponents['city'] ?? 'Unknown City',
                  style: AppStyles.bold20(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (addressComponents['country'] != null) ...[
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: context.theme.blue100_1.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                addressComponents['country']!,
                style: AppStyles.medium12(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({
    super.key,
    required this.age,
    required this.bio,
    this.name,
  });

  final int? age;
  final String? bio;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.white100_1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header with Age
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.theme.blue100_1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person,
                  color: context.theme.white100_1,
                  size: 24,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (name != null) ...[
                      Text(
                        name!,
                        style: AppStyles.bold20(context).copyWith(
                          color: context.theme.blue100_1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(4),
                    ],
                    if (age != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: context.theme.blue100_1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$age years old',
                          style: AppStyles.medium12(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Bio Section
          if (bio != null && bio!.isNotEmpty) ...[
            const Gap(16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.theme.blue100_1.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.theme.blue100_1.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: AppStyles.medium14(context).copyWith(
                      color: context.theme.blue100_1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    bio!,
                    style: AppStyles.regular14(context).copyWith(
                      color: context.theme.blue100_1.withOpacity(0.8),
                      height: 1.4,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
