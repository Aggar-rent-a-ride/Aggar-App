import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';

class SignInEmailAndPasswordFields extends StatefulWidget {
  const SignInEmailAndPasswordFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInEmailAndPasswordFields> createState() =>
      _SignInEmailAndPasswordFieldsState();
}

class _SignInEmailAndPasswordFieldsState
    extends State<SignInEmailAndPasswordFields> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomTextField(
            labelText: 'Email',
            hintText: "Enter Email",
            inputType: TextInputType.emailAddress,
            obscureText: false,
            controller: widget.emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          CustomTextField(
            labelText: 'Password',
            hintText: "Enter password",
            inputType: TextInputType.visiblePassword,
            obscureText: _obscurePassword,
            controller: widget.passwordController,
            suffixIcon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility),
            onSuffixIconPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
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
  }
}
