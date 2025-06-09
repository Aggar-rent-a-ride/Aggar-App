import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
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
    final cubit = context.read<AdminVehicleTypeCubit>();
    cubit.setImageFile(null);
    cubit.vehicleTypeNameController.text = typeName;
    cubit.imageUrl = typeImageUrl;

    return PopScope(
        onPopInvoked: (didPop) async {
          if (didPop) {
            final tokenRefreshCubit = context.read<TokenRefreshCubit>();
            final token = await tokenRefreshCubit.getAccessToken();
            if (token != null) {
              await cubit.fetchVehicleTypes(token);
            }
            cubit.resetFields();
          }
        },
        child: BlocListener<AdminVehicleTypeCubit, AdminVehicleTypeState>(
          listener: (context, state) {
            if (state is AdminVehicleTypeDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(context, "Success",
                    "Vehicle Type Deleted Successfully", SnackBarType.success),
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
                                await cubit.fetchVehicleTypes(token);
                              }
                              cubit.resetFields();
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
                                      context
                                          .read<AdminVehicleTypeCubit>()
                                          .deleteVehicleType(token, typeId);
                                    }
                                    if (context.mounted) {
                                      Navigator.pop(
                                          context); // Close the dialog
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
                final cubit = context.read<AdminVehicleTypeCubit>();
                final tokenRefreshCubit = context.read<TokenRefreshCubit>();
                final token = await tokenRefreshCubit.getAccessToken();
                if (token != null) {
                  if (cubit.XformKey.currentState!.validate()) {
                    cubit.updateVehicleType(
                      token,
                      typeId,
                      cubit.vehicleTypeNameController.text,
                      cubit.image,
                      typeImageUrl,
                    );
                  }
                }
              },
            ),
          ),
        ));
  }
}
