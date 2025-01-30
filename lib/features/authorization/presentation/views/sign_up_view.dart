import 'package:aggar/core/helper/get_font_size.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Let's sign you up",
              style: GoogleFonts.inter(
                color: AppColors.myBlack100,
                fontSize: getFontSize(context, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
            const CustomTextField(
              labelText: 'Name',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Say my name",
            ),
            const CustomTextField(
              labelText: 'Date of birth',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter your age",
            ),
            const CustomTextField(
              labelText: 'Email',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter your Email",
            ),
            const CustomTextField(
              labelText: 'Password',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter password",
              suffixIcon: Icon(Icons.visibility_off),
            ),
            const Gap(65),
            Center(
              child: CustomElevatedButton(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.myBlue100_1,
                height: 60,
                width: 320,
                onPressed: () {},
                child: Text(
                  "Next",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.myWhite100_1,
                  ),
                ),
              ),
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account?"),
                const Gap(5),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "Login now",
                    //TODO : this too will put in app_styles.dart file
                    style: GoogleFonts.inter(
                      fontSize: getFontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: AppColors.myBlue100_1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
