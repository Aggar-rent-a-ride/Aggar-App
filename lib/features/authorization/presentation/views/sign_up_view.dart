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
        BlocProvider(
          create: (context) {
            final signUpCubit = context.read<SignUpCubit>();
            return PickImageCubit(
              userData: signUpCubit.userData,
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
      body: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          final SignUpCubit cubit = context.read<SignUpCubit>();

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
              BlocBuilder<PickImageCubit, PickImageState>(
                builder: (context, pickImageState) {
                  return PickImage(
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
