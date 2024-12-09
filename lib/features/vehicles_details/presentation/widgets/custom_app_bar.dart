import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            flag: true,
          ),
          // TODO : style here want to change
          Text(
            "Vehicles Details",
            style: GoogleFonts.inter(
              color: AppColors.myBlack100,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const CustomIconButton(
            icon: Icons.favorite_border,
            flag: true,
          ),
        ],
      ),
    );
  }
}
