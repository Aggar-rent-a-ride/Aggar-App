import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_image_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_image_state.dart';
import 'package:aggar/features/authorization/presentation/views/verification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/card_type.dart';
import 'package:aggar/features/authorization/presentation/widget/pick_image_icon_with_title_and_subtitle.dart';
import 'package:aggar/features/authorization/presentation/widget/terms_check.dart';

class PickImage extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final PageController? controller;
  final Function(Map<String, dynamic>)? onRegistrationSuccess;
  final VoidCallback onSubmit;

  const PickImage({
    super.key,
    this.userData,
    this.controller,
    this.onRegistrationSuccess,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    // Use the existing PickImageCubit from the parent widget
    // Instead of creating a new one, we'll use BlocBuilder directly
    return PickImageContent(
      controller: controller,
      onRegistrationSuccess: onRegistrationSuccess,
      onSubmit: onSubmit,
    );
  }
}

class PickImageContent extends StatelessWidget {
  final PageController? controller;
  final Function(Map<String, dynamic>)? onRegistrationSuccess;
  final VoidCallback onSubmit;

  const PickImageContent({
    super.key,
    this.controller,
    this.onRegistrationSuccess,
    required this.onSubmit,
  });

  void _previousPage(BuildContext context) {
    if (controller != null) {
      controller!.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PickImageCubit, PickImageState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          context.read<PickImageCubit>().resetError();
        }

        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );

          if (onRegistrationSuccess != null) {
            onRegistrationSuccess!(
                {ApiKey.message: 'Registration successful!'});
          }

          final registrationResponse =
              context.read<PickImageCubit>().registrationResponse;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationView(
                userData: registrationResponse,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppLightColors.myWhite100_1,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pick image:",
                      style: AppStyles.regular20(context),
                    ),
                    PickImageIconWithTitleAndSubtitle(
                      onImageSelected: (path) {
                        context
                            .read<PickImageCubit>()
                            .updateSelectedImage(path);
                      },
                      selectedImagePath: state.selectedImagePath,
                    ),
                    const Gap(20),
                    Text(
                      "Choose type:",
                      style: AppStyles.regular20(context),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: CardType(
                            title: "User",
                            subtitle: "Can use cars & buy for them",
                            isSelected: state.selectedType == "user",
                            onTap: () {
                              context
                                  .read<PickImageCubit>()
                                  .updateSelectedType("user");
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CardType(
                            title: "Renter",
                            subtitle: "Can rent cars & get money",
                            isSelected: state.selectedType == "renter",
                            onTap: () {
                              context
                                  .read<PickImageCubit>()
                                  .updateSelectedType("renter");
                            },
                          ),
                        ),
                      ],
                    ),
                    const Gap(25),
                    TermsCheck(
                      onChanged: (accepted) {
                        context
                            .read<PickImageCubit>()
                            .updateTermsAccepted(accepted);
                      },
                      isChecked: state.termsAccepted,
                    ),
                    const Gap(30),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: state.isLoading
                                ? null
                                : () => _previousPage(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: state.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : CustomElevatedButton(
                                  onPressed: state.isFormValid
                                      ? () {
                                          context
                                              .read<PickImageCubit>()
                                              .register(context);
                                          onSubmit();
                                        }
                                      : null,
                                  text: 'Register',
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
