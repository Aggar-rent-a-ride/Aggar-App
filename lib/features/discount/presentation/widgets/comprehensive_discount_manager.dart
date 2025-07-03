import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:aggar/features/discount/presentation/widgets/discount_card.dart';
import 'package:aggar/features/discount/presentation/widgets/no_discount_yet_section.dart';
import 'package:aggar/features/discount/presentation/widgets/note_discount_section.dart';
import 'package:aggar/features/discount/presentation/widgets/number_of_days_and_persentage_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ComprehensiveDiscountManager extends StatelessWidget {
  final String vehicleId;
  final bool isEditing;
  final VoidCallback? onDiscountsUpdated;
  final List<dynamic>? discounts;

  const ComprehensiveDiscountManager({
    super.key,
    required this.vehicleId,
    this.isEditing = false,
    this.onDiscountsUpdated,
    this.discounts,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize discounts if provided
    if (discounts != null && discounts!.isNotEmpty) {
      context.read<DiscountCubit>().initializeDiscounts(discounts!);
    }

    return BlocConsumer<DiscountCubit, DiscountState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Discounts:',
              style: AppStyles.bold22(context).copyWith(
                color: context.theme.blue100_2,
              ),
            ),
            const Gap(10),
            const NumberOfDaysAndPersentageRow(),
            const Gap(15),
            const NoteDiscountSection(),
            const Gap(15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<DiscountCubit>().addDiscountToList();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.blue100_5,
                      foregroundColor: context.theme.white100_1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add to List'),
                  ),
                ),
                const Gap(10),
                if (isEditing)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (vehicleId.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar(
                              context,
                              "Error",
                              "Vehicle ID is missing. Cannot add discounts.",
                              SnackBarType.error,
                            ),
                          );
                          return;
                        }
                        context.read<DiscountCubit>().addDiscount(vehicleId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.theme.green100_1,
                        foregroundColor: context.theme.white100_1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save Discounts'),
                    ),
                  ),
              ],
            ),
            const Gap(20),
            _buildDiscountList(context, state),
            const Gap(20),
          ],
        );
      },
    );
  }

  Widget _buildDiscountList(BuildContext context, DiscountState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Discounts',
              style: AppStyles.bold18(context).copyWith(
                color: context.theme.blue100_5,
              ),
            ),
            if (state.discounts.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.theme.green100_1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${state.discounts.length} discount${state.discounts.length == 1 ? '' : 's'}',
                  style: AppStyles.medium12(context).copyWith(
                    color: context.theme.green100_1,
                  ),
                ),
              ),
          ],
        ),
        const Gap(15),
        if (state is DiscountLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (state.discounts.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.discounts.length,
            separatorBuilder: (context, index) => const Gap(10),
            itemBuilder: (context, index) {
              final discount = state.discounts[index];
              return Dismissible(
                key: Key('discount_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: context.theme.red100_1,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  context.read<DiscountCubit>().removeDiscount(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Error",
                      "Discount Removed!",
                      SnackBarType.error,
                    ),
                  );
                },
                child: DiscountCard(
                  discount: discount,
                  index: index,
                ),
              );
            },
          )
        else
          const NoDiscountYetSection(),
      ],
    );
  }
}
