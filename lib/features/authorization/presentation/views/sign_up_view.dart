import 'package:aggar/core/helper/get_font_size.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_feild.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          ),
        ],
      ),
    );
  }
}
