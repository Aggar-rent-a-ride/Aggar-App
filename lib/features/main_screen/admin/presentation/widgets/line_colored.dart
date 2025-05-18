import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class LineColored extends StatelessWidget {
  const LineColored({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      decoration: BoxDecoration(
        color: context.theme.yellow100_1,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
