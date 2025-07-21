import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_constants.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_elevated_button.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_location_cubit.dart';
import 'package:aggar/features/authorization/data/cubit/pick_image/pick_location_state.dart';
import 'package:aggar/features/authorization/presentation/widget/back_out_line_button.dart';
import 'package:aggar/features/authorization/presentation/widget/card_type.dart';
import 'package:aggar/features/authorization/presentation/widget/terms_check.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_location_on_map_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/selected_location_map_contnet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../widget/custom_text_from_felid.dart';
import 'verification_view.dart';

class PickLocation extends StatelessWidget {
  final PageController? controller;
  final Function(Map<String, dynamic>)? onRegistrationSuccess;
  final VoidCallback onSubmit;

  const PickLocation({
    super.key,
    this.controller,
    this.onRegistrationSuccess,
    required this.onSubmit,
  });

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }
    if (value.trim().length < 10) {
      return 'Address must be at least 10 characters long';
    }
    return null;
  }

  String? _validateUserType(String selectedType) {
    if (selectedType.isEmpty) {
      return 'Please select a user type';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String uniqueId = const Uuid().v4();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocConsumer<PickLocationCubit, PickLocationState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Sign Up Error: Point on Map is not Certified, Check App Permissions",
              SnackBarType.error,
            ),
          );
          context.read<PickLocationCubit>().resetError();
        }

        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Success",
              "Registration successful!",
              SnackBarType.success,
            ),
          );

          if (onRegistrationSuccess != null) {
            onRegistrationSuccess!({
              ApiKey.message: 'Registration successful!',
            });
          }

          final registrationResponse = context
              .read<PickLocationCubit>()
              .registrationResponse;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerificationView(userData: registrationResponse),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<PickLocationCubit>();
        return Scaffold(
          backgroundColor: context.theme.white100_1,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location and Address",
                          style: AppStyles.medium20(
                            context,
                          ).copyWith(color: context.theme.black100),
                        ),
                        const Gap(20),
                        CustomTextField(
                          labelText: 'Address',
                          inputType: TextInputType.streetAddress,
                          obscureText: false,
                          hintText: "Enter your address",
                          controller: cubit.addressController,
                          onChanged: (value) => cubit.updateAddress(value),
                          validator: _validateAddress,
                        ),
                        const Gap(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Location",
                                style: AppStyles.medium20(
                                  context,
                                ).copyWith(color: context.theme.black100),
                              ),
                            ),
                            FormField<LatLng>(
                              validator: (value) {
                                if (state.latitude.isEmpty ||
                                    state.longitude.isEmpty) {
                                  return 'Please select a location on the map';
                                }
                                final lat = double.tryParse(state.latitude);
                                final lon = double.tryParse(state.longitude);
                                if (lat == null || lat < -90 || lat > 90) {
                                  return 'Invalid latitude';
                                }
                                if (lon == null || lon < -180 || lon > 180) {
                                  return 'Invalid longitude';
                                }
                                return null;
                              },
                              builder: (field) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (state.latitude.isEmpty &&
                                        state.longitude.isEmpty)
                                      PickLocationOnMapButton(
                                        color: context.theme.black10,
                                        textColor: context.theme.black100,
                                        onPickLocation:
                                            (
                                              LatLng location,
                                              String locationAddress,
                                            ) {
                                              cubit.updateLatitude(
                                                location.latitude.toString(),
                                              );
                                              cubit.updateLongitude(
                                                location.longitude.toString(),
                                              );
                                              cubit.updateAddress(
                                                locationAddress,
                                              );
                                              field.didChange(location);
                                            },
                                      )
                                    else
                                      SelectedLocationMapContent(
                                        location: LatLng(
                                          double.tryParse(state.latitude) ??
                                              0.0,
                                          double.tryParse(state.longitude) ??
                                              0.0,
                                        ),
                                        address: cubit.addressController.text,
                                        onEditLocation:
                                            (
                                              LatLng location,
                                              String locationAddress,
                                            ) {
                                              cubit.updateLatitude(
                                                location.latitude.toString(),
                                              );
                                              cubit.updateLongitude(
                                                location.longitude.toString(),
                                              );
                                              cubit.updateAddress(
                                                locationAddress,
                                              );
                                              field.didChange(location);
                                            },
                                        uniqueId: uniqueId,
                                      ),
                                    if (field.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 4.0,
                                        ),
                                        child: Text(
                                          field.errorText!,
                                          style: AppStyles.regular14(context)
                                              .copyWith(
                                                color: context.theme.red100_1,
                                              ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        const Gap(20),
                        Text(
                          "Choose type:",
                          style: AppStyles.regular20(
                            context,
                          ).copyWith(color: context.theme.black100),
                        ),
                        const Gap(10),
                        FormField<String>(
                          initialValue: state.selectedType,
                          validator: (value) =>
                              _validateUserType(state.selectedType),
                          builder: (field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CardType(
                                        title: "Customer",
                                        subtitle: "Can use cars & buy for them",
                                        isSelected:
                                            state.selectedType == "user",
                                        onTap: () {
                                          cubit.updateSelectedType("user");
                                          field.didChange("user");
                                        },
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: CardType(
                                        title: "Renter",
                                        subtitle: "Can rent cars & get money",
                                        isSelected:
                                            state.selectedType == "renter",
                                        onTap: () {
                                          cubit.updateSelectedType("renter");
                                          field.didChange("renter");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if (field.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 4.0,
                                    ),
                                    child: Text(
                                      field.errorText!,
                                      style: AppStyles.regular14(
                                        context,
                                      ).copyWith(color: context.theme.red100_1),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const Gap(25),
                        TermsCheck(
                          onChanged: (accepted) {
                            cubit.updateTermsAccepted(accepted);
                          },
                          isChecked: state.termsAccepted,
                        ),
                        const Gap(30),
                        Row(
                          children: [
                            Expanded(
                              child: BackOutLineButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () => cubit.previousPage(context),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              child: state.isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: AppConstants.myWhite100_1,
                                      ),
                                    )
                                  : state.termsAccepted
                                  ? CustomElevatedButton(
                                      onPressed: () {
                                        // Trigger form validation before registration
                                        if (formKey.currentState!.validate()) {
                                          cubit.register(context);
                                          onSubmit();
                                        }
                                      },
                                      text: 'Register',
                                    )
                                  : Container(
                                      width:
                                          MediaQuery.sizeOf(context).width *
                                          0.85,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Register',
                                          style: AppStyles.bold20(context)
                                              .copyWith(
                                                color: Colors.grey.shade600,
                                              ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
