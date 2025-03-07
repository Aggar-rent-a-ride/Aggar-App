import 'package:flutter/material.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';

class SignUpAllFields extends StatefulWidget {
  final Function(Map<String, String>) onFormDataChanged;
  
  const SignUpAllFields({
    super.key,
    required this.onFormDataChanged,
  });

  @override
  State<SignUpAllFields> createState() => _SignUpAllFieldsState();
}

class _SignUpAllFieldsState extends State<SignUpAllFields> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateFormData);
    _usernameController.addListener(_updateFormData);
    _dateController.addListener(_updateFormData);
    _emailController.addListener(_updateFormData);
    _passwordController.addListener(_updateFormData);
    _confirmPasswordController.addListener(_updateFormData);
  }

  void _updateFormData() {
    widget.onFormDataChanged({
      'name': _nameController.text,
      'username': _usernameController.text,
      'dateOfBirth': _dateController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'confirmPassword': _confirmPasswordController.text,
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _dateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          labelText: 'Name',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter your name",
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        CustomTextField(
          labelText: 'Username',
          inputType: TextInputType.text,
          obscureText: false,
          hintText: "Enter name other users will see",
          controller: _usernameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a username';
            }
            return null;
          },
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your date of birth';
                }
                return null;
              },
            ),
          ),
        ),
        CustomTextField(
          labelText: 'Email',
          inputType: TextInputType.emailAddress,
          obscureText: false,
          hintText: "Enter your Email",
          controller: _emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        CustomTextField(
          labelText: 'Password',
          inputType: TextInputType.text,
          obscureText: !_passwordVisible,
          hintText: "Enter password",
          controller: _passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          suffixIcon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onSuffixIconPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
        CustomTextField(
          labelText: 'Confirm Password',
          inputType: TextInputType.text,
          obscureText: !_confirmPasswordVisible,
          hintText: "Enter your password again",
          controller: _confirmPasswordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            } else if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          suffixIcon: Icon(
            _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onSuffixIconPressed: () {
            setState(() {
              _confirmPasswordVisible = !_confirmPasswordVisible;
            });
          },
        ),
      ],
    );
  }
}