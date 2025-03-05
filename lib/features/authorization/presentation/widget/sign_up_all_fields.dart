import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:flutter/material.dart';

class SignUpAllFields extends StatefulWidget {
  const SignUpAllFields({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpAllFieldsState createState() => _SignUpAllFieldsState();
}

class _SignUpAllFieldsState extends State<SignUpAllFields> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomTextField(
          labelText: 'Name',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter your name",
        ),
        const CustomTextField(
          labelText: 'Username',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter name other users will see",
        ),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: CustomTextField(
              labelText: 'Date of birth',
              inputType: TextInputType.none,
              obscureText: false,
              hintText: "Select your birth date",
              controller: _dateController,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          ),
        ),
        const CustomTextField(
          labelText: 'Email',
          inputType: TextInputType.emailAddress,
          obscureText: false,
          hintText: "Enter your Email",
        ),
        const CustomTextField(
          labelText: 'Password',
          inputType: TextInputType.text,
          obscureText: true,
          hintText: "Enter password",
          suffixIcon: Icon(Icons.visibility_off),
        ),
        const CustomTextField(
          labelText: 'Confirm Password',
          inputType: TextInputType.text,
          obscureText: true,
          hintText: "Enter you password again",
          suffixIcon: Icon(Icons.visibility_off),
        ),
      ],
    );
  }
}
