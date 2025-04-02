import 'package:aggar/features/authorization/data/cubit/pick_image/pick_image_state.dart';
import 'package:aggar/features/authorization/data/cubit/sign_up/sign_up_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/sign_up/sign_up_state.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'credentials.dart';
import 'personal_info.dart';
import 'pick_image.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit()),
        // We'll create the PickImageCubit at this level so it persists throughout navigation
        BlocProvider(
          create: (context) {
            final signUpCubit = context.read<SignUpCubit>();
            return PickImageCubit(
              userData: signUpCubit.userData,
              // We'll pass a null controller here, and set it properly in the StatefulWidget
            );
          },
        ),
      ],
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
  void initState() {
    super.initState();
    // Set the controller for the PickImageCubit after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PickImageCubit>().setPageController(_pageController);
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
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign Up Successful!')),
            );
          } else if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign Up Failed: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          final SignUpCubit cubit = context.read<SignUpCubit>();
          
          // Also listen to changes in the SignUpCubit and update the PickImageCubit
          if (context.read<PickImageCubit>().userData != cubit.userData) {
            context.read<PickImageCubit>().updateUserData(cubit.userData);
          }

          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              PersonalInfoPage(
                controller: _pageController,
                initialData: cubit.userData,
                onFormDataChanged: (data) {
                  cubit.updateFormData(data);
                },
              ),
              CredentialsPage(
                controller: _pageController,
                initialData: cubit.userData,
                onFormDataChanged: (data) {
                  cubit.updateFormData(data);
                },
              ),
              // Use the existing PickImageCubit instead of creating a new one
              BlocBuilder<PickImageCubit, PickImageState>(
                builder: (context, pickImageState) {
                  return PickImage(
                    // We don't pass userData here because the cubit already has it
                    controller: _pageController,
                    onRegistrationSuccess: (data) {
                      cubit.updateFormData(data);
                    },
                    onSubmit: () {
                      cubit.submitSignUp();
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}