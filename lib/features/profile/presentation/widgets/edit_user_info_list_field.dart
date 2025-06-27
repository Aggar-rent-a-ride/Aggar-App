import 'package:aggar/core/cubit/edit_user_info/edit_user_info_cubit.dart';
import 'package:aggar/core/cubit/edit_user_info/edit_user_info_state.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/widgets/pick_user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditUserInfoListField extends StatelessWidget {
  const EditUserInfoListField({
    super.key,
    required this.cubit,
  });

  final EditUserInfoCubit cubit;

  // Date validation method
  String? _validateDateFormat(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }

    // Check if the format matches YYYY-MM-DD
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value.trim())) {
      return 'Date format must be YYYY-MM-DD (e.g., 1990-06-24)';
    }

    // Parse and validate the actual date
    try {
      final parts = value.trim().split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // Basic date validation
      if (year < 1900 || year > DateTime.now().year) {
        return 'Please enter a valid year';
      }
      if (month < 1 || month > 12) {
        return 'Month must be between 01 and 12';
      }
      if (day < 1 || day > 31) {
        return 'Day must be between 01 and 31';
      }

      // Create DateTime to validate the date (this will throw if invalid)
      final date = DateTime(year, month, day);

      // Check if the date is not in the future
      if (date.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }

      // Optional: Check minimum age (e.g., must be at least 13 years old)
      final minDate = DateTime.now().subtract(const Duration(days: 365 * 13));
      if (date.isAfter(minDate)) {
        return 'You must be at least 13 years old';
      }
    } catch (e) {
      return 'Please enter a valid date';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          CustomTextField(
            controller: cubit.nameController,
            hintText: "Enter your name ",
            labelText: "Name",
            inputType: TextInputType.name,
            obscureText: false,
            validator: (String? value) {
              final cubit = context.read<EditUserInfoCubit>();
              final controllerValue = cubit.nameController.text;

              if (controllerValue.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          CustomTextField(
            controller: cubit.bioController,
            hintText: "Enter your Bio",
            labelText: "Bio",
            inputType: TextInputType.multiline,
            obscureText: false,
            maxLines: 3,
          ),
          CustomTextField(
            controller: cubit.dateOfBirthController,
            hintText: "Enter your date of birth (YYYY-MM-DD)",
            labelText: "Date of Birth",
            inputType: TextInputType.datetime,
            obscureText: false,
            validator: _validateDateFormat,
          ),
          BlocBuilder<EditUserInfoCubit, EditUserInfoState>(
            builder: (context, state) {
              return PickUserLocation(
                initialLocation: cubit.selectedLocation,
              );
            },
          ),
          CustomTextField(
            controller: cubit.addressController,
            hintText: "Enter your address",
            labelText: "Address",
            inputType: TextInputType.streetAddress,
            obscureText: false,
            validator: (String? value) {
              final cubit = context.read<EditUserInfoCubit>();
              final controllerValue = cubit.addressController.text;

              if (controllerValue.trim().isEmpty) {
                return 'Address is required';
              }
              return null;
            },
          ),
          const Gap(20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final cubit = context.read<EditUserInfoCubit>();
                if (context
                        .read<EditUserInfoCubit>()
                        .formKey
                        .currentState
                        ?.validate() ??
                    false) {
                  final tokenCubit = context.read<TokenRefreshCubit>();
                  final token = await tokenCubit.getAccessToken();
                  if (token != null) {
                    await cubit.editProfile(token: token);
                    await context
                        .read<UserInfoCubit>()
                        .fetchUserInfo("22", token);
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                      context,
                      "Warning",
                      "Please fill in all required fields",
                      SnackBarType.warning));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.blue100_1,
                foregroundColor: context.theme.white100_1,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Save Changes",
                style: AppStyles.medium16(context).copyWith(
                  color: context.theme.white100_1,
                ),
              ),
            ),
          ),
          const Gap(90),
        ],
      ),
    );
  }
}
