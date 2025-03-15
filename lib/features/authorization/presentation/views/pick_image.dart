import 'package:aggar/core/api/dio_consumer.dart';
import 'package:aggar/core/api/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/presentation/widget/card_type.dart';
import 'package:aggar/features/authorization/presentation/widget/pick_image_icon_with_title_and_subtitle.dart';
import 'package:aggar/features/authorization/presentation/widget/terms_check.dart';

class PickImage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final PageController? controller;

  const PickImage({
    super.key,
    this.userData,
    this.controller,
  });

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  String selectedType = "user";
  bool termsAccepted = false;
  String? selectedImagePath;

  void _onImageSelected(String path) {
    setState(() {
      selectedImagePath = path;
    });
  }

  void _onTermsChanged(bool accepted) {
    setState(() {
      termsAccepted = accepted;
    });
  }

  void _previousPage() {
    if (widget.controller != null) {
      widget.controller!.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  bool get _isFormValid => selectedImagePath != null && termsAccepted;

  void _onRegister() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image and accept the terms.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Combine all user data
    final Map<String, dynamic> completeUserData = {
      ...(widget.userData ?? {}),
      'userType': selectedType,
      'profileImage': selectedImagePath,
      'termsAccepted': termsAccepted,
    };
    DioConsumer(dio: Dio()).post(
      EndPoint.register,
      data: completeUserData,
    );

    print('Registration data: $completeUserData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
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
                  onImageSelected: _onImageSelected,
                  selectedImagePath: selectedImagePath,
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
                        isSelected: selectedType == "user",
                        onTap: () {
                          setState(() {
                            selectedType = "user";
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CardType(
                        title: "Renter",
                        subtitle: "Can rent cars & get money",
                        isSelected: selectedType == "renter",
                        onTap: () {
                          setState(() {
                            selectedType = "renter";
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(25),
                TermsCheck(
                  onChanged: _onTermsChanged,
                  isChecked: termsAccepted,
                ),
                const Gap(30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: _isFormValid ? _onRegister : null,
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
  }
}
