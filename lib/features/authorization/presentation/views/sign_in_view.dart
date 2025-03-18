import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/views/verification_view.dart';
import 'package:aggar/features/authorization/presentation/widget/divider_with_text.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_do_not_have_an_account_section.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_email_and_password_fields.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_face_book_and_google_buttons.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_forget_password_button.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_image_with_text.dart';
import 'package:aggar/features/main_screen/presentation/views/main_screen.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (formKey.currentState!.validate()) {
      print('Email: ${emailController.text}');
      print('Password: ${passwordController.text}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
      // Call login API
    }
  }

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
            const SignInImageWithText(),
            SignInEmailAndPasswordFields(
              emailController: emailController,
              passwordController: passwordController,
              formKey: formKey,
            ),
            SignInForgetPasswordButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const VerificationView();
                }));
              },
            ),
            CustomElevatedButton(
              onPressed: _handleLogin,
              text: 'Login',
            ),
            const DividerWithText(),
            const SignInFaceBookAndGoogleButtons(),
            const SignInDoNotHaveAnAccountSection(),
          ],
        ),
      ),
    );
  }
}
