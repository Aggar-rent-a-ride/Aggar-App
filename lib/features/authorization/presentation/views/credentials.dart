import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/authorization/data/cubit/credentials/credentials_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/credentials/credentials_state.dart';
import 'package:aggar/features/authorization/presentation/widget/back_out_line_button.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';

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
    print('Validating form, email: ${cubit.emailController.text}, '
        'password: ${cubit.passwordController.text}, '
        'confirm: ${cubit.confirmPasswordController.text}'); // Debug

    // Trigger validation for all fields
    final formState = cubit.formKey.currentState;
    if (formState != null) {
      final isValid = formState.validate();
      if (isValid) {
        controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  String? _validateEmail(String? value) {
    print('Validating email: $value'); // Debug
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email (e.g., user@example.com)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    print('Validating password: $value'); // Debug
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).+$')
        .hasMatch(value)) {
      return 'Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value, String password) {
    print('Validating confirm password: $value, password: $password'); // Debug
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
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
            backgroundColor: context.theme.white100_1,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Credentials",
                            style: AppStyles.medium20(context).copyWith(
                              color: context.theme.black100,
                            ),
                          ),
                          const Gap(10),
                          CustomTextField(
                            labelText: 'Email',
                            inputType: TextInputType.emailAddress,
                            obscureText: false,
                            hintText: "Enter your Email",
                            controller: cubit.emailController,
                            onChanged: cubit.updateEmail,
                            validator: _validateEmail,
                          ),
                          const Gap(15),
                          CustomTextField(
                            labelText: 'Password',
                            inputType: TextInputType.text,
                            obscureText: !state.passwordVisible,
                            hintText: "Enter password",
                            controller: cubit.passwordController,
                            onChanged: cubit.updatePassword,
                            validator: (value) => _validatePassword(value),
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
                            controller: cubit.confirmPasswordController,
                            onChanged: cubit.updateConfirmPassword,
                            validator: (value) =>
                                _validateConfirmPassword(value, state.password),
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
                                child: BackOutLineButton(
                                  onPressed: _previousPage,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: CustomElevatedButton(
                                  onPressed: () => _nextPage(context),
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
            ),
          );
        },
      ),
    );
  }
}
