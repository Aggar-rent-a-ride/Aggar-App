import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';

class DiscountCard extends StatelessWidget {
  final DiscountItem discount;
  final int index;

  const DiscountCard({
    super.key,
    required this.discount,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Days Required: ${discount.daysRequired}',
                style: AppStyles.regular14(context),
              ),
              const Gap(8),
              Text(
                'Discount: ${discount.discountPercentage}%',
                style: AppStyles.regular14(context),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<DiscountCubit>().removeDiscount(index);
            },
          ),
        ],
      ),
    );
  }
}

class AddDiscountForm extends StatelessWidget {
  const AddDiscountForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DiscountCubit>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Discount',
            style: AppStyles.semiBold16(context),
          ),
          const Gap(16),
          TextField(
            controller: cubit.daysRequired,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Days Required',
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(16),
          TextField(
            controller: cubit.discountPercentage,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Discount Percentage',
              border: OutlineInputBorder(),
            ),
          ),
          const Gap(16),
          ElevatedButton(
            onPressed: () {
              cubit.addDiscountToList();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppLightColors.myBlue100_5,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Add Discount'),
          ),
        ],
      ),
    );
  }
}
