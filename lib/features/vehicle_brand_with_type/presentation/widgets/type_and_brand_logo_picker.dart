import 'dart:io';
import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_brand/edit_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_brand/edit_vehicle_brand_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_type/edit_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/edit_vehicle_type/edit_vehicle_type_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class TypeAndBrandLogoPicker extends StatelessWidget {
  const TypeAndBrandLogoPicker({
    super.key,
    required this.logoType,
    required this.isEditing,
  });

  final String logoType;
  final bool isEditing;

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      if (logoType == 'Brand') {
        if (isEditing) {
          context.read<EditVehicleBrandCubit>().setImageFile(imageFile);
        } else {
          context.read<AdminVehicleBrandCubit>().setImageFile(imageFile);
        }
      } else {
        if (isEditing) {
          context.read<EditVehicleTypeCubit>().setImageFile(imageFile);
        } else {
          context.read<AdminVehicleTypeCubit>().setImageFile(imageFile);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (logoType == 'Brand' && isEditing) {
          return BlocBuilder<EditVehicleBrandCubit, EditVehicleBrandState>(
            buildWhen: (previous, current) =>
                current is EditVehicleBrandImageUpdated ||
                current is EditVehicleBrandInitial,
            builder: (context, state) {
              final image = context.read<EditVehicleBrandCubit>().image;
              final imageUrl = context.read<EditVehicleBrandCubit>().imageUrl;
              return _buildLogoPicker(context, image, imageUrl);
            },
          );
        } else if (logoType == 'Type' && isEditing) {
          return BlocBuilder<EditVehicleTypeCubit, EditVehicleTypeState>(
            buildWhen: (previous, current) =>
                current is EditVehicleTypeImageUpdated ||
                current is EditVehicleTypeInitial,
            builder: (context, state) {
              final image = context.read<EditVehicleTypeCubit>().image;
              final imageUrl = context.read<EditVehicleTypeCubit>().imageUrl;
              return _buildLogoPicker(context, image, imageUrl);
            },
          );
        } else if (logoType == 'Brand') {
          return BlocBuilder<AdminVehicleBrandCubit, AdminVehicleBrandState>(
            buildWhen: (previous, current) =>
                current is AdminVehicleBrandImageUpdated ||
                current is AdminVehicleBrandInitial,
            builder: (context, state) {
              final image = context.read<AdminVehicleBrandCubit>().image;
              final imageUrl = context.read<AdminVehicleBrandCubit>().imageUrl;
              return _buildLogoPicker(context, image, imageUrl);
            },
          );
        } else {
          return BlocBuilder<AdminVehicleTypeCubit, AdminVehicleTypeState>(
            buildWhen: (previous, current) =>
                current is AdminVehicleTypeImageUpdated ||
                current is AdminVehicleTypeInitial,
            builder: (context, state) {
              final image = context.read<AdminVehicleTypeCubit>().image;
              final imageUrl = context.read<AdminVehicleTypeCubit>().imageUrl;
              return _buildLogoPicker(context, image, imageUrl);
            },
          );
        }
      },
    );
  }

  Widget _buildLogoPicker(BuildContext context, File? image, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$logoType Logo (Optional)",
          style: AppStyles.semiBold14(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        const Gap(10),
        GestureDetector(
          onTap: () => _pickImage(context),
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.theme.blue10_2,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(image, fit: BoxFit.contain),
                  )
                : imageUrl != null && imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          EndPoint.baseUrl + imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder(context);
                          },
                        ),
                      )
                    : _buildPlaceholder(context),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.assetsIconsPickimage,
          height: 50,
          width: 50,
        ),
        Text(
          textAlign: TextAlign.center,
          "click here to pick \n$logoType image ",
          style: AppStyles.regular15(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
      ],
    );
  }
}
