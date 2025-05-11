import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TransmissionFilterChip extends StatefulWidget {
  const TransmissionFilterChip({
    super.key,
  });

  @override
  State<TransmissionFilterChip> createState() => _TransmissionFilterChipState();
}

class _TransmissionFilterChipState extends State<TransmissionFilterChip> {
  bool isTransmissionSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      backgroundColor: context.theme.white100_1,
      selectedColor: context.theme.blue100_6,
      checkmarkColor: context.theme.white100_1,
      selected: isTransmissionSelected,
      labelPadding: const EdgeInsets.all(0),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(
            "Transmission",
            style: AppStyles.semiBold15(context).copyWith(
              color: isTransmissionSelected
                  ? context.theme.white100_1
                  : context.theme.blue100_8,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_rounded,
            size: 20,
            color: isTransmissionSelected
                ? context.theme.white100_1
                : context.theme.blue100_8,
          )
        ],
      ),
      onSelected: (bool selected) {
        setState(() {
          isTransmissionSelected = selected;
        });
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const SizedBox();
          },
        );
      },
    );
  }
}
