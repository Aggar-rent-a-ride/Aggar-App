import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:aggar/features/discount/presentation/widgets/custom_display_discount_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Dismissible(
      key: Key('discount_$index'),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: context.theme.red100_1,
        child: Icon(
          Icons.delete,
          color: context.theme.white100_1,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<DiscountCubit>().removeDiscount(index);
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content:
                  const Text('Are you sure you want to delete this discount?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.white100_2,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomDisplayDiscountColumn(
                  hint: "days",
                  subtitle: discount.daysRequired.toString(),
                  title: 'Days Required:',
                ),
                CustomDisplayDiscountColumn(
                  hint: "%",
                  subtitle: discount.discountPercentage.toString(),
                  title: 'Discount Percentage:',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
