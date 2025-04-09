import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:aggar/features/discount/presentation/widgets/yes_no_buttons_row.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscountCubit(),
      child: const DiscountScreenView(),
    );
  }
}

class DiscountScreenView extends StatelessWidget {
  const DiscountScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppLightColors.myWhite100_1,
      appBar: AppBar(
        elevation: 1,
        shadowColor: AppLightColors.myBlack50,
        centerTitle: false,
        backgroundColor: AppLightColors.myWhite100_1,
        title: Text(
          'Discounts',
          style: AppStyles.semiBold24(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: BlocBuilder<DiscountCubit, DiscountState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                Text(
                  'Add Discount to this vehicle ?',
                  style: AppStyles.bold22(context).copyWith(
                    color: AppLightColors.myBlue100_5,
                  ),
                ),
                const Gap(20),
                const YesNoButtonsRow(
                  isSelected: false,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<DiscountCubit, DiscountState>(
        builder: (context, state) {
          return BottomNavigationBarContent(
            title: "Continue",
            onPressed: () {},
          );
        },
      ),
    );
  }
}
