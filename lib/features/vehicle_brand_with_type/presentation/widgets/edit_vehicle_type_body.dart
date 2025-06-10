import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_type/edit_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_type/edit_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/text_with_text_field_type_and_brand.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/type_and_brand_logo_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditVehicleTypeBody extends StatelessWidget {
  const EditVehicleTypeBody({
    super.key,
    required this.typeName,
    required this.typeImageUrl,
  });
  final String typeName;
  final String typeImageUrl;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditVehicleTypeCubit>();
    return BlocListener<EditVehicleTypeCubit, EditVehicleTypeState>(
      listener: (context, state) {
        if (state is EditVehicleTypeUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Success",
                "Vehicle Type Updated Successfully", SnackBarType.success),
          );
          // Navigation is handled in the screen widget
        } else if (state is EditVehicleTypeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Error", "Error: ${state.message}",
                SnackBarType.error),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWithTextFieldTypeAndBrand(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid Vehicle Type Name";
                  }
                  return null;
                },
                controller: cubit.vehicleTypeNameController,
                label: "Vehicle Type Name",
              ),
              const Gap(25),
              const TypeAndBrandLogoPicker(
                isEditing: true,
                logoType: "Type",
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}
