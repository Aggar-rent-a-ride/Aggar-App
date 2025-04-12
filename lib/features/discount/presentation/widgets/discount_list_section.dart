import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:aggar/features/discount/presentation/widgets/add_discount_button.dart';
import 'package:aggar/features/discount/presentation/widgets/add_discount_form.dart';
import 'package:aggar/features/discount/presentation/widgets/discount_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';

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
            Text(
              'Discount List:',
              style: AppStyles.semiBold18(context).copyWith(
                color: AppLightColors.myBlue100_5,
              ),
            ),
            const Gap(15),
            // Display all discount cards
            if (state.discounts.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.discounts.length,
                separatorBuilder: (context, index) => const Gap(10),
                itemBuilder: (context, index) {
                  return DiscountCard(
                    discount: state.discounts[index],
                    index: index,
                  );
                },
              )
            else
              const Text('No discounts added yet'),
            const Gap(20),
            // Add the discount form
            const AddDiscountForm(),
            const Gap(20),
            // Button to save all discounts to the API
            AddDiscountButton(
              onPressed: () {
                print("Save All Discounts Button Pressed");
                context.read<DiscountCubit>().addDiscount("146");
              },
              text: 'Save All Discounts',
            ),
          ],
        );
      },
    );
  }
}
