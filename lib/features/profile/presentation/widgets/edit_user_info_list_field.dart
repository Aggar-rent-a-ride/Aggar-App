import 'package:aggar/core/cubit/edit_user_info/edit_user_info_cubit.dart';
import 'package:aggar/core/cubit/edit_user_info/edit_user_info_state.dart';
import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/authorization/presentation/widget/custom_text_from_felid.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/widgets/pick_user_location.dart';
import 'package:aggar/features/profile/presentation/widgets/date_of_birth_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../authorization/data/cubit/Login/login_cubit.dart';

class EditUserInfoListField extends StatelessWidget {
  const EditUserInfoListField({
    super.key,
    required this.cubit,
  });

  final EditUserInfoCubit cubit;

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
          DateOfBirthPicker(
            controller: cubit.dateOfBirthController,
            onDateSelected: (selectedDate) {},
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
                  final token = await tokenCubit.ensureValidToken();
                  if (token != null) {
                    await cubit.editProfile(token: token);
                    String? userId =
                        await context.read<LoginCubit>().getUserId();
                    await context
                        .read<UserInfoCubit>()
                        .fetchUserInfo(userId!, token);
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackBar(
                      context,
                      "Warning",
                      "Please fill in all required fields",
                      SnackBarType.warning,
                    ),
                  );
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
