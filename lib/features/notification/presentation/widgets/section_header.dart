import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String markTitle;

  const SectionHeader(
      {required this.title, super.key, required this.markTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              markTitle,
              style: TextStyle(fontSize: 12, color: AppColors.myBlue100_2),
            ),
          ),
        ],
      ),
    );
  }
}