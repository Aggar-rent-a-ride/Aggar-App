import 'package:aggar/core/helper/get_font_size.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/authorization/presentation/views/page_view.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:aggar/features/authorization/presentation/widget/divider_with_text.dart';
import 'package:aggar/features/authorization/presentation/widget/social_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

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
                fontSize: getFontSize(context, 24),
                fontWeight: FontWeight.bold,
              ),
            ),
            const CustomTextField(
              labelText: 'Email',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter Email",
            ),
            const CustomTextField(
              labelText: 'Password',
              inputType: TextInputType.text,
              obscureText: false,
              hintText: "Enter password",
              suffixIcon: Icon(Icons.visibility_off),
            ),
            GestureDetector(
              onTap: () {},
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "Forget password?",
                    style: GoogleFonts.inter(
                      fontSize: getFontSize(context, 14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.myBlue100_1,
                    ),
                  ),
                ),
              ),
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
            const DividerWithText(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton(
                  textColor: AppColors.myWhite100_3,
                  icon: const CustomIcon(
                    hight: 40,
                    width: 40,
                    flag: false,
                    imageIcon: AppAssets.assetsIconsFacebookIcon,
                  ),
                  color: Colors.blue,
                  text: 'Facebook',
                ),
                const SizedBox(width: 20),
                SocialButton(
                  textColor: AppColors.myBlack100,
                  icon: const CustomIcon(
                    hight: 40,
                    width: 40,
                    flag: false,
                    imageIcon: AppAssets.assetsIconsGoogleIcon,
                  ),
                  color: AppColors.myWhite100_3,
                  text: 'Google',
                ),
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const Gap(5),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScrollViewHome(),
                        ));
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "Register now",
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
