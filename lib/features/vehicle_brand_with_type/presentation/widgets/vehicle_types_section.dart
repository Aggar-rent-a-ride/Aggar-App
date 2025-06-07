import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/vehicle_type_card_net_work_image.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/add_vehicle_type_or_brand_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleTypesSection extends StatefulWidget {
  const VehicleTypesSection({super.key});

  @override
  State<VehicleTypesSection> createState() => _VehicleTypesSectionState();
}

class _VehicleTypesSectionState extends State<VehicleTypesSection> {
  bool _showAll = false;
  final int _initialDisplayCount = 8;

  void _toggleShowAll() {
    setState(() {
      _showAll = !_showAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminVehicleTypeCubit, AdminVehicleTypeState>(
      builder: (context, state) {
        if (state is AdminVehicleTypeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminVehicleTypeLoaded) {
          final vehicleTypes = state.listVehicleTypeModel.data;
          if (vehicleTypes.isEmpty) {
            return Text(
              "No vehicle types available",
              style: AppStyles.regular16(context).copyWith(
                color: context.theme.blue100_1,
              ),
            );
          }
          final displayTypes = _showAll
              ? vehicleTypes
              : vehicleTypes.take(_initialDisplayCount).toList();
          final showSeeAllButton = vehicleTypes.length > _initialDisplayCount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Text(
                  "Vehicle Types",
                  style: AppStyles.bold18(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ),
              Wrap(
                runSpacing: 5,
                children: [
                  ...displayTypes.map((vehicleType) {
                    return VehicleTypeCardNetWorkImage(
                      iconPrv: "null",
                      label: vehicleType.name,
                    );
                  }),
                  if (showSeeAllButton)
                    IconButton(
                      onPressed: _toggleShowAll,
                      icon: Icon(
                        _showAll
                            ? Icons.arrow_drop_up_outlined
                            : Icons.arrow_drop_down_outlined,
                        color: context.theme.blue100_1,
                      ),
                    ),
                ],
              ),
              const AddVehicleTypeOrBrandButton(
                text: "Add Vehicle Type",
              ),
            ],
          );
        } else if (state is AdminVehicleTypeError) {
          return Text(
            state.message,
            style: AppStyles.regular16(context).copyWith(
              color: context.theme.red100_1,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
