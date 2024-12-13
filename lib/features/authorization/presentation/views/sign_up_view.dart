import 'package:aggar/core/helper/get_font_size.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';
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
            const SizedBox(
              height: 15,
            ),
            const CustomTextField(
              labelText: 'Date of birth',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter your age",
            ),
            const SizedBox(
              height: 15,
            ),
            const CustomTextField(
              labelText: 'Email',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter your Email",
            ),
            const SizedBox(
              height: 15,
            ),
            const CustomTextField(
              labelText: 'Password',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter password",
              suffixIcon: Icon(Icons.visibility_off),
            ),
            const SizedBox(
              height: 80,
            ),
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
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
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
