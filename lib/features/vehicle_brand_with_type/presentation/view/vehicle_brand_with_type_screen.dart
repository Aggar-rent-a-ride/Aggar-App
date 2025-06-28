import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/vehicle_settings_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleBrandWithTypeScreen extends StatelessWidget {
  const VehicleBrandWithTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AdminVehicleBrandCubit>().resetFields();
        final tokenCubit = context.read<TokenRefreshCubit>();
        final token = await tokenCubit.getAccessToken();
        if (token != null) {
          await context.read<AdminVehicleTypeCubit>().fetchVehicleTypes(token);
          await context
              .read<AdminVehicleBrandCubit>()
              .fetchVehicleBrands(token);
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
                      left: 25, right: 25, top: 65, bottom: 16),
                  child: Row(
                    children: [
                      Text(
                        "Vehicle Services",
                        style: AppStyles.bold20(context).copyWith(
                          color: context.theme.white100_1,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const VehicleSettingsBody(),
              ],
            ),
          ),
        ),
        backgroundColor: context.theme.white100_1,
      ),
    );
  }
}
