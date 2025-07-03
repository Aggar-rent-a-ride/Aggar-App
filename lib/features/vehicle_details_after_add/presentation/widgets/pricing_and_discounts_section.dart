import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class PricingAndDiscountsSection extends StatelessWidget {
  const PricingAndDiscountsSection({
    super.key,
    required this.discountList,
    required this.price,
  });

  final List<dynamic> discountList;
  final double price;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing & Discounts',
          style: AppStyles.bold18(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
        const Gap(10),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Base Price (per day)',
                style: AppStyles.semiBold16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              const Gap(5),
              Text(
                currencyFormatter.format(price),
                style: AppStyles.bold36(context).copyWith(
                  color: context.theme.blue100_2,
                ),
              ),
              const Gap(5),
              Text(
                'This is the standard daily rental rate before any applicable discounts.',
                style: AppStyles.regular14(context).copyWith(
                  color: context.theme.black100.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        if (discountList.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Available Discounts',
            style: AppStyles.bold18(context).copyWith(
              color: context.theme.blue100_2,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: discountList.length,
            itemBuilder: (context, index) {
              final discount = discountList[index];
              final daysRequired = discount['daysRequired'] as int;
              final discountPercentage = discount['discountPercentage'] as num;
              final discountedPrice =
                  discount['discountedPricePerDay'] as double;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.theme.white100_1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppLightColors.myBlue100_2.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$daysRequired+ Days Rental',
                      style: AppStyles.semiBold16(context).copyWith(
                        color: context.theme.black100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$discountPercentage% Off',
                          style: AppStyles.regular14(context).copyWith(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${currencyFormatter.format(discountedPrice)}/day',
                          style: AppStyles.regular16(context).copyWith(
                            color: context.theme.blue100_2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ] else ...[
          const SizedBox(height: 16),
          Text(
            'No discounts available at this time.',
            style: AppStyles.regular14(context).copyWith(
              color: context.theme.black100.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}
