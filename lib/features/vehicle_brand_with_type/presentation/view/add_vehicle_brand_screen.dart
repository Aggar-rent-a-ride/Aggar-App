import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/bottom_navigation_bar_content.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/add_vehicle_brand_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVehicleBrandScreen extends StatelessWidget {
  const AddVehicleBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AdminVehicleBrandCubit>().resetFields();
    return Scaffold(
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: context.theme.white100_1,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Vehicle Brand",
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const AddVehicleBrandBody(),
            ],
          ),
        ),
      ),
      backgroundColor: context.theme.white100_1,
      bottomNavigationBar: BottomNavigationBarContent(
        color: context.theme.blue100_1,
        title: "Create Brand",
        onPressed: () async {
          final cubit = context.read<AdminVehicleBrandCubit>();
          final tokenRefreshCubit = context.read<TokenRefreshCubit>();
          final token = await tokenRefreshCubit.getAccessToken();
          if (token != null) {
            if (cubit.YformKey.currentState!.validate()) {
              cubit.createVehicleBrand(
                token,
                cubit.vehicleBrandNameController.text,
                cubit.image,
                cubit.vehicleBrandCountryController.text,
              );
            }
          }
        },
      ),
    );
  }
}
