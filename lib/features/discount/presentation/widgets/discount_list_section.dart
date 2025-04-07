import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/widgets/add_discount_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';
import 'discount_input_field.dart';

class DiscountListSection extends StatelessWidget {
  const DiscountListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountCubit, DiscountState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount List :',
                  style: AppStyles.semiBold18(context).copyWith(
                    color: AppLightColors.myBlue100_5,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                  color: AppLightColors.myBlack50,
                ),
              ],
            ),
            const Gap(15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppLightColors.myBlack50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          hintText: 'ex: 8',
                          suffixText: 'days',
                          initialValue: state.days,
                          onChanged: (value) =>
                              context.read<DiscountCubit>().updateDays(value),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: DiscountInputField(
                          hintText: 'ex: 25',
                          suffixText: '%',
                          initialValue: state.percentage,
                          onChanged: (value) => context
                              .read<DiscountCubit>()
                              .updatePercentage(value),
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
            ),
            const Gap(20),
            const AddDiscountButton(),
          ],
        );
      },
    );
  }
}
