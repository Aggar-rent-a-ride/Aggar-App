import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NameAndEmailSection extends StatelessWidget {
  const NameAndEmailSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adele Adkins',
          style: TextStyle(
            color: AppColors.myBlack100,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'adeleissomeceleb@gmail.com',
          style: TextStyle(
            color: AppColors.myGray100_2,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
