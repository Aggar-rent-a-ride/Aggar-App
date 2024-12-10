import 'package:aggar/core/helper/get_font_size.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_elvated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_feild.dart';
import 'package:aggar/features/authorization/presentation/widget/divider_with_text.dart';
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
            Image(
              image: const AssetImage(AppAssets.assetsImagesSignUpImg),
              width: MediaQuery.sizeOf(context).width * 0.5,
              height: 200,
              fit: BoxFit.fitWidth,
            ),
            Text(
              "Let's log you in",
              style: GoogleFonts.inter(
                color: AppColors.myBlack100,
                fontSize: getFontSize(context, 28),
                fontWeight: FontWeight.bold,
              ),
            ),
            const CustomTextField(
              lableText: 'Email',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter Email",
            ),
            const CustomTextField(
              lableText: 'Password',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter password",
              suffixIcon: Icon(Icons.visibility_off),
            ),
            const SizedBox(
              height: 25,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Forget password?",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.myBlue100_1,
                ),
              ),
            ),
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
                  "Login",
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
            const DividerWithText(),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SocialButton(
                  icon: Icons.facebook, //AppAssets.assetsIconsFacebookIcon
                  color: Colors.blue,
                  text: 'Facebook',
                ),
                const SizedBox(width: 20),
                SocialButton(
                  icon: Icons.g_mobiledata, //AppAssets.assetsIconsGoogleIcon
                  color: AppColors.myWhite100_3,
                  text: 'Google',
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Register now",
                    style: GoogleFonts.inter(
                      fontSize: 14,
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

class SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const SocialButton({
    required this.icon,
    required this.color,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
