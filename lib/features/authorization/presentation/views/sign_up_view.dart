import 'package:aggar/features/authorization/data/cubit/sign_up/sign_up_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'credentials.dart';
import 'personal_info.dart';
import 'pick_image.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: const SignUpPageView(),
    );
  }
}

class SignUpPageView extends StatefulWidget {
  const SignUpPageView({super.key});

  @override
  State<SignUpPageView> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends State<SignUpPageView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            // Handle successful sign-up
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign Up Successful: ${state.userData}')),
            );
          } else if (state is SignUpFailure) {
            // Handle sign-up failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign Up Failed: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              PersonalInfoPage(
                controller: _pageController,
                onFormDataChanged: (data) {
                  context.read<SignUpCubit>().updateFormData(data);
                },
              ),
              CredentialsPage(
                controller: _pageController,
                onFormDataChanged: (data) {
                  context.read<SignUpCubit>().updateFormData(data);
                },
              ),
              PickImage(
                userData: context.read<SignUpCubit>().userData,
                controller: _pageController,
                onSubmit: () {
                  context.read<SignUpCubit>().submitSignUp();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
