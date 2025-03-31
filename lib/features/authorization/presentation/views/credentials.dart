import 'package:aggar/features/authorization/data/cubit/credentials/credentials_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/credentials/credentials_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';

class CredentialsPage extends StatelessWidget {
  final PageController controller;
  final Function(Map<String, String>) onFormDataChanged;
  final Map<String, dynamic>? initialData;

  const CredentialsPage({
    super.key,
    required this.controller,
    required this.onFormDataChanged,
    this.initialData,
  });

  void _nextPage(BuildContext context) {
    final cubit = context.read<CredentialsCubit>();
    if (cubit.state.validateEmail() &&
        cubit.state.validatePassword() &&
        cubit.state.validateConfirmPassword()) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CredentialsCubit();

        if (initialData != null) {
          if (initialData!.containsKey('email')) {
            cubit.updateEmail(initialData!['email'] as String);
          }
          if (initialData!.containsKey('password')) {
            cubit.updatePassword(initialData!['password'] as String);
          }
          if (initialData!.containsKey('confirmPassword')) {
            cubit.updateConfirmPassword(
                initialData!['confirmPassword'] as String);
          }
        }

        return cubit;
      },
      child: BlocConsumer<CredentialsCubit, CredentialsState>(
        listener: (context, state) {
          onFormDataChanged({
            'email': state.email,
            'password': state.password,
            'confirmPassword': state.confirmPassword,
          });
        },
        builder: (context, state) {
          final cubit = context.read<CredentialsCubit>();

          return Scaffold(
            backgroundColor: AppLightColors.myWhite100_1,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),
                        Text("Account Credentials",
                            style: AppStyles.medium20(context)),
                        const Gap(10),
                        CustomTextField(
                          labelText: 'Email',
                          inputType: TextInputType.emailAddress,
                          obscureText: false,
                          hintText: "Enter your Email",
                          initialValue: state.email,
                          onChanged: cubit.updateEmail,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!state.validateEmail()) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const Gap(15),
                        CustomTextField(
                          labelText: 'Password',
                          inputType: TextInputType.text,
                          obscureText: !state.passwordVisible,
                          hintText: "Enter password",
                          initialValue: state.password,
                          onChanged: cubit.updatePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (!state.validatePassword()) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffixIcon: Icon(
                            state.passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onSuffixIconPressed: cubit.togglePasswordVisibility,
                        ),
                        const Gap(15),
                        CustomTextField(
                          labelText: 'Confirm Password',
                          inputType: TextInputType.text,
                          obscureText: !state.confirmPasswordVisible,
                          hintText: "Enter your password again",
                          initialValue: state.confirmPassword,
                          onChanged: cubit.updateConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (!state.validateConfirmPassword()) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          suffixIcon: Icon(
                            state.confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onSuffixIconPressed:
                              cubit.toggleConfirmPasswordVisibility,
                        ),
                        const Gap(30),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _previousPage,
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: state.isFormValid
                                    ? () => _nextPage(context)
                                    : null,
                                text: "Next",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
