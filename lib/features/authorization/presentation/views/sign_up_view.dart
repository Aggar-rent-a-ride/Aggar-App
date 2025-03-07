import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_up_all_fields.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_up_have_an_account_section.dart';

class SignUpView extends StatefulWidget {
  final PageController controller;
  final Function(Map<String, String>)? onFormDataSubmitted;
  
  const SignUpView({
    super.key, 
    required this.controller,
    this.onFormDataSubmitted,
  });

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};
  bool _isFormValid = false;

  void _updateFormData(Map<String, String> data) {
    setState(() {
      _formData = data;
      _isFormValid = _formData['name']?.isNotEmpty == true &&
                    _formData['username']?.isNotEmpty == true &&
                    _formData['dateOfBirth']?.isNotEmpty == true &&
                    _formData['email']?.isNotEmpty == true &&
                    _formData['password']?.isNotEmpty == true &&
                    _formData['confirmPassword']?.isNotEmpty == true &&
                    _formData['password'] == _formData['confirmPassword'];
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.onFormDataSubmitted != null) {
        widget.onFormDataSubmitted!(_formData);
      }
        widget.controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(20),
                  Text("Let's sign you up", style: AppStyles.bold28(context)),
                  SignUpAllFields(
                    onFormDataChanged: _updateFormData,
                  ),
                  const Gap(30),
                  CustomElevatedButton(
                    onPressed: _isFormValid ? _submitForm : null,
                    text: "Next",
                  ),
                  const Gap(10),
                  const SignUpHaveAnAccountSection(),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}