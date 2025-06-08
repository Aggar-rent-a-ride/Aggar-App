import 'dart:math';

import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/text_with_text_field_type_and_brand.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/type_and_brand_logo_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CreateVehicleTypeBody extends StatelessWidget {
  const CreateVehicleTypeBody({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AdminVehicleTypeCubit>().resetFields();
    return BlocConsumer<AdminVehicleTypeCubit, AdminVehicleTypeState>(
      listener: (context, state) {
        if (state is AdminVehicleTypeAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Success",
                "Vehicle Type Added Successfully", SnackBarType.success),
          );
          Navigator.pop(context);
        } else if (state is AdminVehicleTypeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Error", "Error:$e", SnackBarType.error),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: context.read<AdminVehicleTypeCubit>().XformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithTextFieldTypeAndBrand(
                  controller: context
                      .read<AdminVehicleTypeCubit>()
                      .vehicleTypeNameController,
                  label: "Vehicle Type Name",
                ),
                const Gap(25),
                const TypeAndBrandLogoPicker(
                  logoType: "Type",
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
