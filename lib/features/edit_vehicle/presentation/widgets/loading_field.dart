import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';

class LoadingField extends StatelessWidget {
  const LoadingField({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 80,
            color: context.theme.white100_1,
          ),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.theme.white100_1,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}
