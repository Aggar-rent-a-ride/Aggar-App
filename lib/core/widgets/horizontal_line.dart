import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({
    super.key,
    this.padding,
    this.color,
  });
  final double? padding;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 15),
      child: Divider(
        color: color ?? context.theme.black25,
      ),
    );
  }
}
