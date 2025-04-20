import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
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
            const AddDiscountForm(),
            Text(
              'Discount List:',
              style: AppStyles.bold22(context).copyWith(
                color: context.theme.blue100_5,
              ),
            ),
            const Gap(20),
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
          ],
        );
      },
    );
  }
}
