import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';

class SignUpAllFields extends StatelessWidget {
  const SignUpAllFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(
          labelText: 'Name',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Say my name",
        ),
        CustomTextField(
          labelText: 'Date of birth',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter your age",
        ),
        CustomTextField(
          labelText: 'Email',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter your Email",
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
