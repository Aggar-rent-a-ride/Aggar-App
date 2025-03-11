import 'package:flutter/material.dart';

import 'credentials.dart';
import 'personal_info.dart';
import 'pick_image.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final PageController _pageController = PageController();
  final Map<String, dynamic> _userData = {};

  void _updateFormData(Map<String, String> data) {
    setState(() {
      _userData.addAll(data);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PersonalInfoPage(
            controller: _pageController,
            onFormDataChanged: _updateFormData,
          ),
          CredentialsPage(
            controller: _pageController,
            onFormDataChanged: _updateFormData,
          ),
          PickImage(
            userData: _userData,
            controller: _pageController,
          ),
        ],
      ),
    );
  }
}