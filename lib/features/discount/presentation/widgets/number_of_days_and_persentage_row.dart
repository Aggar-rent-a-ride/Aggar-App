import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/widgets/discount_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class NumberOfDaysAndPersentageRow extends StatelessWidget {
  const NumberOfDaysAndPersentageRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number of days:',
                style: AppStyles.semiBold16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              const Gap(10),
              DiscountInputField(
                controller: context.read<DiscountCubit>().daysRequired,
                hintText: 'ex: 8',
                suffixText: 'days',
              ),
            ],
          ),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Percentage',
                style: AppStyles.semiBold16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              const Gap(10),
              DiscountInputField(
                controller: context.read<DiscountCubit>().discountPercentage,
                hintText: 'ex: 25',
                suffixText: '%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
