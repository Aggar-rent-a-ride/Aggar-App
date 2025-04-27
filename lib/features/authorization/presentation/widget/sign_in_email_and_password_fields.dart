import 'package:aggar/features/authorization/data/cubit/Login/login_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/Login/login_state.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInIdentifierAndPasswordFields extends StatelessWidget {
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const SignInIdentifierAndPasswordFields({
    super.key,
    required this.identifierController,
    required this.passwordController,
    required this.formKey,
    required bool obscurePassword,
    required void Function() togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          current is LoginPasswordVisibilityChanged || previous is LoginInitial,
      builder: (context, state) {
        final obscurePassword = state is LoginPasswordVisibilityChanged
            ? state.obscurePassword
            : loginCubit.obscurePassword;

        return Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                labelText: 'Email or Username',
                hintText: "Enter Email or Username",
                inputType: TextInputType.text,
                obscureText: false,
                controller: identifierController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email or Username is required';
                  }

                  if (value.contains('@')) {
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                  }

                  return null;
                },
              ),
              CustomTextField(
                labelText: 'Password',
                hintText: "Enter password",
                inputType: TextInputType.visiblePassword,
                obscureText: obscurePassword,
                controller: passwordController,
                suffixIcon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility),
                onSuffixIconPressed: () {
                  loginCubit.togglePasswordVisibility();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
