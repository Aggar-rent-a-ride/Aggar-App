import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_state.dart';
import 'package:aggar/features/authorization/presentation/views/verification_view.dart';
import 'package:aggar/features/authorization/presentation/widget/divider_with_text.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_do_not_have_an_account_section.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_email_and_password_fields.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_face_book_and_google_buttons.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_forget_password_button.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_image_with_text.dart';
import 'package:aggar/features/main_screen/presentation/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createLoginCubit(),
      child: const _SignInContent(),
    );
  }

  LoginCubit _createLoginCubit() {
    final dio = Dio();
    const secureStorage = FlutterSecureStorage();
    return LoginCubit(
      dioConsumer: DioConsumer(dio: dio),
      secureStorage: secureStorage,
    );
  }
}

class _SignInContent extends StatelessWidget {
  const _SignInContent();

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return Scaffold(
      backgroundColor: context.theme.white100_1,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MainScreen()));
          } else if (state is LoginInactiveAccount) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationView(
                  userData: state.userData,
                ),
              ),
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(20),
                    const SignInImageWithText(),
                    SignInEmailAndPasswordFields(
                      emailController: loginCubit.emailController,
                      passwordController: loginCubit.passwordController,
                      formKey: loginCubit.formKey,
                    ),
                    const Gap(20),
                    SignInForgetPasswordButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerificationView(),
                          ),
                        );
                      },
                    ),
                    const Gap(10),
                    CustomElevatedButton(
                      onPressed: isLoading ? null : loginCubit.handleLogin,
                      text: 'Login',
                      isLoading: isLoading,
                    ),
                    const Gap(20),
                    const DividerWithText(),
                    const Gap(20),
                    const SignInFaceBookAndGoogleButtons(),
                    const Gap(10),
                    const SignInDoNotHaveAnAccountSection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
