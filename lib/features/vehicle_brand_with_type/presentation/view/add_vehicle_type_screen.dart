import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/add_vehicle_type_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVehicleTypeScreen extends StatelessWidget {
  const AddVehicleTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminVehicleTypeCubit>();
    // Reset fields only on initial load
    if (cubit.vehicleTypeNameController.text.isEmpty) {
      cubit.resetFields();
    }

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          final tokenRefreshCubit = context.read<TokenRefreshCubit>();
          final token = await tokenRefreshCubit.ensureValidToken();
          if (token != null) {
            await cubit.fetchVehicleTypes(token);
          }
          cubit.resetFields();
        }
      },
      child: BlocListener<AdminVehicleTypeCubit, AdminVehicleTypeState>(
        listener: (context, state) {
          if (state is AdminVehicleTypeAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(context, "Success",
                  "Vehicle Type Created Successfully", SnackBarType.success),
            );
            cubit.resetFields(); // Reset after successful creation
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
                                await tokenRefreshCubit.ensureValidToken();
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
                          "Vehicle Type",
                          style: AppStyles.bold20(context).copyWith(
                            color: context.theme.white100_1,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          child: Text(
                            "Cancel",
                            style: AppStyles.semiBold16(context).copyWith(
                              color: context.theme.white100_1,
                            ),
                          ),
                          onPressed: () async {
                            final tokenRefreshCubit =
                                context.read<TokenRefreshCubit>();
                            final token =
                                await tokenRefreshCubit.ensureValidToken();
                            if (token != null) {
                              await cubit.fetchVehicleTypes(token);
                            }
                            cubit.resetFields();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const CreateVehicleTypeBody(),
                ],
              ),
            ),
          ),
          backgroundColor: context.theme.white100_1,
          bottomNavigationBar: BottomNavigationBarContent(
            color: context.theme.blue100_1,
            title: "Create Type",
            onPressed: () async {
              final tokenRefreshCubit = context.read<TokenRefreshCubit>();
              final token = await tokenRefreshCubit.ensureValidToken();
              if (token != null && cubit.formKey.currentState!.validate()) {
                await cubit.createVehicleType(
                  token,
                  cubit.vehicleTypeNameController.text,
                  cubit.image,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
