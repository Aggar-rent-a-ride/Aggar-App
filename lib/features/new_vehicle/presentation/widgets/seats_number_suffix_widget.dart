import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SeatsNumberSuffixWidget extends StatelessWidget {
  const SeatsNumberSuffixWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: context.theme.black50,
          ),
        ),
      ),
      child: Text(
        "person",
        style: AppStyles.medium15(context).copyWith(
          color: context.theme.black50,
        ),
      ),
    );
  }
}
