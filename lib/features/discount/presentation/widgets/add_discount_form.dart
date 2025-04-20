import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/discount/presentation/widgets/add_discount_button_list.dart';
import 'package:aggar/features/discount/presentation/widgets/note_discount_section.dart';
import 'package:aggar/features/discount/presentation/widgets/number_of_days_and_persentage_row.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddDiscountForm extends StatelessWidget {
  const AddDiscountForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            boxShadow: [
              BoxShadow(
                color: context.theme.black25,
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            children: [
              NumberOfDaysAndPersentageRow(),
              Gap(15),
              NoteDiscountSection()
            ],
          ),
        ),
        const Gap(15),
        const AddDiscountButtonList(),
      ],
    );
  }
}
