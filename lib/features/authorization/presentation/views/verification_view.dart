import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/data/cubit/verification/verification_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/verification/verification_state.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationView extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const VerificationView({
    super.key,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerificationCubit(userData: userData),
      child: const VerificationViewContent(),
    );
  }
}

class VerificationViewContent extends StatelessWidget {
  const VerificationViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppLightColors.myRed100_1,
            ),
          );
          context.read<VerificationCubit>().resetError();
        }

        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to home or dashboard
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SignInView();
          }));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppLightColors.myWhite100_1,
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: AppLightColors.myWhite100_1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title:
                Text('Verification Screen', style: AppStyles.medium24(context)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {},
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: Column(
                children: [
                  Image.asset(
                    AppAssets.assetsImagesVerificationIcon,
                    height: 150,
                  ),
                  const Gap(25),
                  Text(
                    'Please enter the verification code sent to:',
                    style: AppStyles.regular20(context)
                        .copyWith(color: AppLightColors.myGray100_2),
                  ),
                  Text(
                    state.email ?? 'your email',
                    style: AppStyles.semiBold20(context),
                  ),
                  const Gap(40),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onChanged: (value) {
                      context.read<VerificationCubit>().updateCode(value);
                    },
                    textStyle: GoogleFonts.poppins(fontSize: 18),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: AppLightColors.myBlue100_1,
                      inactiveColor: AppLightColors.myGray100_2,
                      selectedColor: AppLightColors.myBlue100_2,
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive the code?",
                          style: AppStyles.regular20(context)
                              .copyWith(color: AppLightColors.myGray100_2)),
                      TextButton(
                        onPressed: state.isResending
                            ? null
                            : () => context
                                .read<VerificationCubit>()
                                .sendVerificationCode(),
                        child: state.isResending
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppLightColors.myBlue100_1,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sending...',
                                    style: AppStyles.bold22(context).copyWith(
                                        color: AppLightColors.myBlue100_1),
                                  ),
                                ],
                              )
                            : Text(
                                'Resend it',
                                style: AppStyles.bold22(context).copyWith(
                                    color: AppLightColors.myBlue100_1),
                              ),
                      )
                    ],
                  ),
                  const Gap(30),
                  state.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppLightColors.myBlue100_1,
                          ),
                        )
                      : CustomElevatedButton(
                          onPressed: state.isFormValid
                              ? () =>
                                  context.read<VerificationCubit>().verifyCode()
                              : null,
                          text: "Verify",
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
