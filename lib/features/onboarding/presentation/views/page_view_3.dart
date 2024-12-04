import 'package:aggar/core/helper/get_font_size.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class PageView3 extends StatelessWidget {
  const PageView3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.myWhite100,
      child: Column(
        children: [
          Image(
            image: const AssetImage(
              AppAssets.assetsImagesImg3,
            ),
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.fitWidth,
          ),
          const Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book your car ",
                  //TODO : it will changes and put in app_style file
                  style: GoogleFonts.inter(
                    color: AppColors.myBlack100,
                    fontSize: getFontSize(context, 30),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(70),
                Text(
                  "Agger offers a wide range of vehicles to suit your needs, ensuring a smooth and convenient booking experience.",
                  //TODO : this too will put in app_styles.dart file
                  style: GoogleFonts.inter(
                    color: AppColors.myBlack50,
                    fontSize: getFontSize(context, 18),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
