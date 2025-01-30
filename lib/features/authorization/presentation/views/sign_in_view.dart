import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/authorization/presentation/widget/divider_with_text.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_donot_have_an_account_section.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_email_and_password_fields.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_face_book_and_google_buttons.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_forget_password_button.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_image_with_text.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_login_button.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInImageWithText(),
            SignInEmailAndPasswordFields(),
            SignInForgetPasswordButton(),
            SignInLoginButton(),
            DividerWithText(),
            SignInFaceBookAndGoogleButtons(),
            SignInDonotHaveAnAccountSection(),
          ],
        ),
      ),
    );
  }
}
