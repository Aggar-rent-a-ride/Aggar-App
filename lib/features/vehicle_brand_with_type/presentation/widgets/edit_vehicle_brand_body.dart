import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_brand/edit_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_brand/edit_vehicle_brand_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/text_with_text_field_type_and_brand.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/type_and_brand_logo_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditVehicleBrandBody extends StatelessWidget {
  const EditVehicleBrandBody({
    super.key,
    required this.brandName,
    required this.brandImageUrl,
    required this.brandCountry,
  });

  final String brandName;
  final String brandImageUrl;
  final String brandCountry;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditVehicleBrandCubit>();
    return BlocConsumer<EditVehicleBrandCubit, EditVehicleBrandState>(
      listener: (context, state) {
        if (state is EditVehicleBrandUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Success",
                "Vehicle Brand Updated Successfully", SnackBarType.success),
          );
        } else if (state is EditVehicleBrandError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(context, "Error", "Error: ${state.message}",
                SnackBarType.error),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWithTextFieldTypeAndBrand(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid Vehicle Brand Name";
                    }
                    return null;
                  },
                  controller: cubit.vehicleBrandNameController,
                  label: "Vehicle Brand Name",
                ),
                const Gap(25),
                TextWithTextFieldTypeAndBrand(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid Vehicle Brand Country";
                    }
                    return null;
                  },
                  controller: cubit.vehicleBrandCountryController,
                  label: "Vehicle Brand Country",
                ),
                const Gap(25),
                const TypeAndBrandLogoPicker(
                  isEditing: true,
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
