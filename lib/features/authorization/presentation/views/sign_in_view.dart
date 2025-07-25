import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_state.dart';
import 'package:aggar/features/authorization/presentation/views/verification_view.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_do_not_have_an_account_section.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_email_and_password_fields.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_image_with_text.dart';
import 'package:aggar/features/main_screen/admin/presentation/views/admin_bottom_navigation_bar.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/customer_bottom_navigation_bar_views.dart';
import 'package:aggar/features/main_screen/renter/presentation/views/renter_bottom_navigation_bar_view.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
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
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                context,
                "Success",
                "Sign In successful!",
                SnackBarType.success,
              ),
            );
            final userType = state.userType;
            if (userType == "Admin") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminBottomNavigationBar(),
                ),
              );
            } else if (userType == "Customer") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const CustomerBottomNavigationBarViews(),
                ),
              );
            } else if (userType == "Renter") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RenterBottomNavigationBarView(),
                ),
              );
            }
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
              customSnackBar(
                context,
                "Error",
                "Sign In Error: ${state.errorMessage}",
                SnackBarType.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SignInImageWithText(),
                    SignInIdentifierAndPasswordFields(
                      identifierController: loginCubit.identifierController,
                      passwordController: loginCubit.passwordController,
                      formKey: loginCubit.formKey,
                      obscurePassword: loginCubit.obscurePassword,
                      togglePasswordVisibility:
                          loginCubit.togglePasswordVisibility,
                    ),
                    // const Gap(5),
                    // const SignInForgetPasswordButton(),
                    const Gap(20),
                    CustomElevatedButton(
                      onPressed: () {
                        isLoading ? null : loginCubit.handleLogin();
                        context.read<MessageCubit>().clearCache();
                      },
                      text: 'Login',
                      isLoading: isLoading,
                    ),
                    const Gap(20),
                    //const DividerWithText(),
                    // const Gap(20),
                    // const SignInFaceBookAndGoogleButtons(),
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
