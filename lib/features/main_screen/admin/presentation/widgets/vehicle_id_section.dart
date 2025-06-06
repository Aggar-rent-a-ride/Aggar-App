import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class IdSection extends StatelessWidget {
  const IdSection({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: context.theme.black100.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "ID: $id",
          style: AppStyles.regular13(context).copyWith(
            color: context.theme.white100_2,
          ),
        ),
      ),
    );
  }
}
