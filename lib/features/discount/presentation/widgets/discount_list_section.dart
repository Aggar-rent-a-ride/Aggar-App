import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:aggar/features/discount/presentation/widgets/add_discount_button.dart';
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
              'Discount List :',
              style: AppStyles.semiBold18(context).copyWith(
                color: AppLightColors.myBlue100_5,
              ),
            ),
            const Gap(15),
            const DiscountCard(),
            const Gap(20),
            AddDiscountButton(
              onPressed: () {
                context.read<DiscountCubit>().addDiscount("146");
              },
            ),
          ],
        );
      },
    );
  }
}
