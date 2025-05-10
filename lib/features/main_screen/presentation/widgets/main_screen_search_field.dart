import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class MainScreenSearchField extends StatelessWidget {
  const MainScreenSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onTap: () {},
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: AppStyles.regular18(context).copyWith(
            color: context.theme.black100.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
