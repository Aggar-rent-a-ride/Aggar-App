import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDiscountButtonList extends StatelessWidget {
  const AddDiscountButtonList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<DiscountCubit>().addDiscountToList();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Discount'),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.blue100_1,
          foregroundColor: context.theme.white100_1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
