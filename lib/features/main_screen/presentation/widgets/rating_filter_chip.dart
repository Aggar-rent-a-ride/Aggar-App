import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class RatingFilterChip extends StatefulWidget {
  const RatingFilterChip({
    super.key,
  });

  @override
  State<RatingFilterChip> createState() => _RatingFilterChipState();
}

class _RatingFilterChipState extends State<RatingFilterChip> {
  bool isRatingSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      backgroundColor: context.theme.white100_1,
      selectedColor: context.theme.blue100_6,
      checkmarkColor: context.theme.white100_1,
      selected: isRatingSelected,
      labelPadding: const EdgeInsets.all(0),
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(
            "Rating",
            style: AppStyles.semiBold15(context).copyWith(
              color: isRatingSelected
                  ? context.theme.white100_1
                  : context.theme.blue100_8,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_rounded,
            size: 20,
            color: isRatingSelected
                ? context.theme.white100_1
                : context.theme.blue100_8,
          )
        ],
      ),
      onSelected: (bool selected) {
        setState(() {
          isRatingSelected = selected;
        });
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
          sheetAnimationStyle: AnimationStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            reverseDuration: const Duration(milliseconds: 300),
            reverseCurve: Curves.ease,
          ),
          context: context,
          builder: (context) {
            return Container(
              height: 150,
            );
          },
        );
      },
    );
  }
}
