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
