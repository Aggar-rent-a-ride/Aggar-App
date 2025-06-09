import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/edit_vehicle_brand_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditVehicleBrandScreen extends StatelessWidget {
  const EditVehicleBrandScreen({
    super.key,
    required this.brandName,
    required this.brandImageUrl,
    required this.brandCountry,
    required this.brandId,
  });

  final String brandName;
  final String brandImageUrl;
  final String brandCountry;
  final int brandId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminVehicleBrandCubit>();
    cubit.setImageFile(null);
    cubit.vehicleBrandNameController.text = brandName;
    cubit.vehicleBrandCountryController.text = brandCountry;
    cubit.imageUrl = brandImageUrl;

    return PopScope(
      onPopInvoked: (didPop) async {
        if (didPop) {
          final tokenRefreshCubit = context.read<TokenRefreshCubit>();
          final token = await tokenRefreshCubit.getAccessToken();
          if (token != null) {
            await cubit.fetchVehicleBrands(token);
          }
          cubit.resetFields();
        }
      },
      child: BlocListener<AdminVehicleBrandCubit, AdminVehicleBrandState>(
        listener: (context, state) {
          if (state is AdminVehicleBrandDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(context, "Success",
                  "Vehicle Brand Deleted Successfully", SnackBarType.success),
            );
            if (context.mounted) {
              Navigator.pop(context);
            }
          } else if (state is AdminVehicleBrandError) {
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
                              await cubit.fetchVehicleBrands(token);
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
                          "Edit Vehicle Brand",
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
                                title: "Delete Vehicle Brand",
                                actionTitle: "Delete",
                                subtitle:
                                    "Are you sure you want to delete $brandName?",
                                onPressed: () async {
                                  final tokenRefreshCubit =
                                      context.read<TokenRefreshCubit>();
                                  final token =
                                      await tokenRefreshCubit.getAccessToken();
                                  if (token != null) {
                                    await cubit.deleteVehicleBrand(
                                        token, brandId);
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
                  EditVehicleBrandBody(
                    brandCountry: brandCountry,
                    brandImageUrl: brandImageUrl,
                    brandName: brandName,
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
              if (token != null) {
                if (cubit.YformKey.currentState!.validate()) {
                  cubit.updateVehicleBrand(
                    token,
                    brandId,
                    cubit.vehicleBrandNameController.text,
                    cubit.image,
                    brandImageUrl,
                    cubit.vehicleBrandCountryController.text,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
