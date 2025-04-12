import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/discount/presentation/widgets/add_discount_button_list.dart';
import 'package:aggar/features/discount/presentation/widgets/number_of_days_and_persentage_row.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddDiscountForm extends StatelessWidget {
  const AddDiscountForm({super.key});

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          NumberOfDaysAndPersentageRow(),
          Gap(15),
          AddDiscountButtonList(),
        ],
      ),
    );
  }
}
