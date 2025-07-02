import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class SpletContainer extends StatelessWidget {
  const SpletContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 7,
        width: 70,
        decoration: BoxDecoration(
          color: context.theme.grey100_1,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
