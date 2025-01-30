import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';

class SignInEmailAndPasswordFields extends StatelessWidget {
  const SignInEmailAndPasswordFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(
          labelText: 'Email',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter Email",
        ),
        CustomTextField(
          labelText: 'Password',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter password",
          suffixIcon: Icon(Icons.visibility_off),
        ),
      ],
    );
  }
}
