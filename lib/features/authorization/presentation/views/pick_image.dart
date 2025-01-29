import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/authorization/presentation/widget/card_type.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/pick_image_icon_with_title_and_subtitle.dart';
import 'package:aggar/features/authorization/presentation/widget/terms_check.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pick image:",
              style: AppStyles.regular20(context),
            ),
            const PickImageIconWithTitleAndSubtitle(),
            Text(
              "Choose type:",
              style: AppStyles.regular20(context),
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
            const Gap(25),
            const TermsCheck(),
            const Gap(5),
            Center(
              child: CustomElevatedButton(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.myBlue100_1,
                width: MediaQuery.sizeOf(context).width * 0.8,
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Register",
                    style: AppStyles.bold18(context).copyWith(
                      color: AppColors.myWhite100_1,
                    ),
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
