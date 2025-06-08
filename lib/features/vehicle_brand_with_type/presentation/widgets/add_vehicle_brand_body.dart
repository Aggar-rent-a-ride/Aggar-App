import 'dart:math';

import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/text_with_text_field_type_and_brand.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/type_and_brand_logo_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddVehicleBrandBody extends StatelessWidget {
  const AddVehicleBrandBody({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AdminVehicleBrandCubit>().resetFields();
    return BlocConsumer<AdminVehicleBrandCubit, AdminVehicleBrandState>(
      listener: (context, state) {
        if (state is AdminVehicleBrandAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Success",
                "Vehicle Brand Added Successfully", SnackBarType.success),
          );
          Navigator.pop(context);
        } else if (state is AdminVehicleBrandError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Error", "Error:$e", SnackBarType.error),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: context.read<AdminVehicleBrandCubit>().YformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithTextFieldTypeAndBrand(
                  controller: context
                      .read<AdminVehicleBrandCubit>()
                      .vehicleBrandNameController,
                  label: "Vehicle Brand Name",
                ),
                const Gap(25),
                TextWithTextFieldTypeAndBrand(
                  controller: context
                      .read<AdminVehicleBrandCubit>()
                      .vehicleBrandCountryController,
                  label: "Vehicle Brand Country",
                ),
                const Gap(25),
                const TypeAndBrandLogoPicker(
                  logoType: "Brand",
                ),
                const Gap(10),
              ],
            ),
          ),
        );
      },
    );
  }
}
