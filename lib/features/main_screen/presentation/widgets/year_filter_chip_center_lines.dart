import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class YearFilterChipCenterLines extends StatelessWidget {
  const YearFilterChipCenterLines({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.theme.black10, width: 1),
            bottom: BorderSide(color: context.theme.black10, width: 1),
          ),
        ),
      ),
    );
  }
}
