import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_cubit.dart';
import 'package:aggar/features/discount/presentation/cubit/discount_state.dart';
import 'package:aggar/features/discount/presentation/widgets/add_discount_button_list.dart';
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

  const ComprehensiveDiscountManager({
    super.key,
    required this.vehicleId,
    this.isEditing = false,
    this.onDiscountsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiscountCubit(
        tokenRefreshCubit: context.read(),
      ),
      child: BlocConsumer<DiscountCubit, DiscountState>(
        listener: (context, state) {
          if (state is DiscountFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: context.theme.red100_1,
              ),
            );
          } else if (state is DiscountSuccess && state.response != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Discounts updated successfully'),
                backgroundColor: context.theme.green100_1,
              ),
            );
            onDiscountsUpdated?.call();
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vehicle Discounts :',
                style: AppStyles.bold22(context).copyWith(
                  color: context.theme.blue100_2,
                ),
              ),
              const Gap(10),
              const Column(
                children: [
                  NumberOfDaysAndPersentageRow(),
                  Gap(15),
                  NoteDiscountSection(),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: AddDiscountButtonList(),
                  ),
                ],
              ),
              const Gap(20),
              _buildDiscountList(context, state),
              const Gap(20),
            ],
          );
        },
      ),
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
              return DiscountCard(
                discount: state.discounts[index],
                index: index,
              );
            },
          )
        else
          const NoDiscountYetSection()
      ],
    );
  }
}
