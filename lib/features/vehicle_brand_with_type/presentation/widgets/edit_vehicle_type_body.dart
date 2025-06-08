import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/text_with_text_field_type_and_brand.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/type_and_brand_logo_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditVehicleTypeBody extends StatelessWidget {
  const EditVehicleTypeBody(
      {super.key, required this.typeName, required this.typeImageUrl});
  final String typeName;
  final String typeImageUrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminVehicleTypeCubit>();
    cubit.vehicleTypeNameController.text = typeName;
    cubit.imageUrl = typeImageUrl;
    return BlocConsumer<AdminVehicleTypeCubit, AdminVehicleTypeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: cubit.XformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithTextFieldTypeAndBrand(
                  initalValue: typeName,
                  controller: cubit.vehicleTypeNameController,
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
      listener: (context, state) {
        if (state is AdminVehicleTypeUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Success",
                "Vehicle Brand Updated Successfully", SnackBarType.success),
          );
          Navigator.pop(context);
        } else if (state is AdminVehicleTypeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
                context, "Error", "Error:${state.message}", SnackBarType.error),
          );
        }
      },
    );
  }
}
