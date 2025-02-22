import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class OverViewSection extends StatelessWidget {
  const OverViewSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              // TODO : style here want to change
              Text(
                "overview",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: AppColors.myGray100_3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.myBlue100_8,
                ),
                // TODO : style here want to change
                child: Text(
                  "Automatic",
                  style: GoogleFonts.inter(
                    color: AppColors.myBlue100_2,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          const Gap(5),
          // TODO : style here want to change
          Text(
            "Discover the with its unique design with innovative SUV code . its characteristic and original design combines power ",
            style: GoogleFonts.inter(
              color: AppColors.myGray100_2,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
