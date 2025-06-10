import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_type/edit_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_type/edit_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/edit_vehicle_type_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditVehicleTypeScreen extends StatelessWidget {
  const EditVehicleTypeScreen({
    super.key,
    required this.typeName,
    required this.typeImageUrl,
    required this.typeId,
  });

  final String typeName;
  final String typeImageUrl;
  final int typeId;

  @override
  Widget build(BuildContext context) {
    final editCubit = context.read<EditVehicleTypeCubit>();
    final adminCubit = context.read<AdminVehicleTypeCubit>();
    // Initialize fields only once
    if (editCubit.vehicleTypeNameController.text.isEmpty) {
      editCubit.vehicleTypeNameController.text = typeName;
      editCubit.imageUrl = typeImageUrl;
      editCubit.setImageFile(null);
    }

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          final tokenRefreshCubit = context.read<TokenRefreshCubit>();
          final token = await tokenRefreshCubit.getAccessToken();
          if (token != null) {
            await adminCubit.fetchVehicleTypes(token);
          }
          // Only reset fields if not saving changes
          editCubit.resetFields();
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<AdminVehicleTypeCubit, AdminVehicleTypeState>(
            listener: (context, state) {
              if (state is AdminVehicleTypeDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                      context,
                      "Success",
                      "Vehicle Type Deleted Successfully",
                      SnackBarType.success),
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } else if (state is AdminVehicleTypeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(context, "Error", "Error: ${state.message}",
                      SnackBarType.error),
                );
              }
            },
          ),
          BlocListener<EditVehicleTypeCubit, EditVehicleTypeState>(
            listener: (context, state) {
              if (state is EditVehicleTypeUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                      context,
                      "Success",
                      "Vehicle Type Updated Successfully",
                      SnackBarType.success),
                );
                final tokenRefreshCubit = context.read<TokenRefreshCubit>();
                tokenRefreshCubit.getAccessToken().then((token) {
                  if (token != null) {
                    adminCubit.fetchVehicleTypes(token);
                  }
                });
                editCubit.resetFields(); // Reset after successful update
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } else if (state is EditVehicleTypeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(context, "Error", "Error: ${state.message}",
                      SnackBarType.error),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.blue100_8,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 65, bottom: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final tokenRefreshCubit =
                                context.read<TokenRefreshCubit>();
                            final token =
                                await tokenRefreshCubit.getAccessToken();
                            if (token != null) {
                              await adminCubit.fetchVehicleTypes(token);
                            }
                            editCubit.resetFields();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: context.theme.white100_1,
                            size: 20,
                          ),
                        ),
                        Text(
                          "Edit Vehicle Type",
                          style: AppStyles.bold20(context).copyWith(
                            color: context.theme.white100_1,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          child: Text(
                            "Delete",
                            style: AppStyles.semiBold16(context).copyWith(
                              color: context.theme.white100_1,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                title: "Delete Vehicle Type",
                                actionTitle: "Delete",
                                subtitle:
                                    "are you sure you want to delete $typeName ?",
                                onPressed: () async {
                                  final tokenCubit =
                                      context.read<TokenRefreshCubit>();
                                  final token =
                                      await tokenCubit.getAccessToken();
                                  if (token != null) {
                                    adminCubit.deleteVehicleType(token, typeId);
                                  }
                                  if (context.mounted) {
                                    Navigator.pop(context); // Close the dialog
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  EditVehicleTypeBody(
                    typeImageUrl: typeImageUrl,
                    typeName: typeName,
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: context.theme.white100_1,
          bottomNavigationBar: BottomNavigationBarContent(
            color: context.theme.blue100_1,
            title: "Save Changes",
            onPressed: () async {
              final tokenRefreshCubit = context.read<TokenRefreshCubit>();
              final token = await tokenRefreshCubit.getAccessToken();
              if (token != null && editCubit.formKey.currentState!.validate()) {
                await editCubit.updateVehicleType(
                  token,
                  typeId,
                  editCubit.vehicleTypeNameController.text,
                  editCubit.image,
                  typeImageUrl,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
