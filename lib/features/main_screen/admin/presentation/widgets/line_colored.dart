import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class LineColored extends StatelessWidget {
  const LineColored({
    super.key,
    this.color,
  });
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      decoration: BoxDecoration(
        color: color ?? context.theme.yellow100_1,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
