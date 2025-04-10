import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/widgets/discount_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppLightColors.myWhite100_1,
        boxShadow: [
          BoxShadow(
            color: AppLightColors.myBlack25,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Number of days:',
                  style: AppStyles.semiBold16(context),
                ),
              ),
              Expanded(
                child: Text(
                  'Percentage',
                  style: AppStyles.semiBold16(context),
                ),
              ),
            ],
          ),
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: DiscountInputField(
                  controller: context.read<DiscountCubit>().daysRequired,
                  hintText: 'ex: 8',
                  suffixText: 'days',
                ),
              ),
              const Gap(10),
              Expanded(
                child: DiscountInputField(
                  controller: context.read<DiscountCubit>().discountPercentage,
                  hintText: 'ex: 25',
                  suffixText: '%',
                ),
              ),
            ],
          ),
          const Gap(15),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Note:\nNumber of days must apply the offer and a percentage must be able to divided by 5',
              style: AppStyles.regular14(context).copyWith(
                color: AppLightColors.myBlack50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
