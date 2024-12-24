import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/authorization/presentation/widget/card_type.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/terms_check.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  String selectedType = "user";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                //TODO : this too will put in app_styles.dart file
                "Pick image:",

                style: TextStyle(
                    fontFamily: "Cairo",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.myBlack100),
                // style: GoogleFonts.cairo(
                //   fontWeight: FontWeight.bold,
                //   fontSize: 24,
                //   color: AppColors.myBlack100,
                // ),
              ),
            ),
            CircleAvatar(
              backgroundColor: AppColors.myBlue100_2,
              radius: 110,
              child: const CustomIcon(
                hight: 110,
                width: 110,
                flag: false,
                imageIcon: AppAssets.assetsIconsAddPhoto,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                //TODO : this too will put in app_styles.dart file
                "Profile photo",
              ),
            ),
            const Text(
              //TODO : this too will put in app_styles.dart file
              "Please make sure that the photo you \n    upload will not be modified later",
              style: TextStyle(color: Colors.grey),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                //TODO : this too will put in app_styles.dart file
                "Choose type:",
              ),
            ),
            Row(
              children: [
                CardType(
                  title: "User",
                  subtitle: "Can use cars & buy for them",
                  isSelected: selectedType == "user",
                  onTap: () {
                    setState(() {
                      selectedType = "user";
                    });
                  },
                ),
                CardType(
                  title: "Renter",
                  subtitle: "Can rent cars & get money",
                  isSelected: selectedType == "renter",
                  onTap: () {
                    setState(() {
                      selectedType = "renter";
                    });
                  },
                ),
              ],
            ),
            const Gap(40),
            const TermsCheck(),
            const Gap(5),
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
