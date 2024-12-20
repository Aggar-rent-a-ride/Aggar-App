import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/authorization/presentation/widget/card_type.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/terms_check.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PickImage extends StatelessWidget {
  const PickImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                //TODO : this too will put in app_styles.dart file
                "Pick an image:",
              ),
            ),
            CircleAvatar(
              backgroundColor: AppColors.myBlue100_2,
              radius: 120,
              child: const CustomIcon(
                hight: 120,
                width: 120,
                flag: false,
                imageIcon: AppAssets.assetsIconsAddPhoto,
              ),
            ),
            const Text(
              //TODO : this too will put in app_styles.dart file
              "Profile photo",
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Please make sure that the photo you upload will not be modified later",
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                //TODO : this too will put in app_styles.dart file
                "Choose type:",
              ),
            ),
            const Row(
              children: [
                CardType(),
                CardType(),
              ],
            ),
            const TermsCheck(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: CustomElevatedButton(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.myBlue100_1,
                height: 60,
                width: 320,
                onPressed: () {},
                child: Text(
                  "Register",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.myWhite100_1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
