import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/vehicle_type_card_net_work_image.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehicle_type/admin_vehicle_type_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/view/add_vehicle_type_screen.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/view/edit_vehicle_type_screen.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/add_vehicle_type_or_brand_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vehicle Types",
                          style: AppStyles.bold18(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          "${vehicleTypes.length} types available",
                          style: AppStyles.regular12(context).copyWith(
                            color: context.theme.blue100_1.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AddVehicleTypeOrBrandButton(
                      text: "Add Type",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddVehicleTypeScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Wrap(
                runSpacing: 5,
                children: [
                  ...displayTypes.map((vehicleType) {
                    return VehicleTypeCardNetWorkImage(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditVehicleTypeScreen(
                              typeImageUrl: vehicleType.slogenPath ?? "null",
                              typeName: vehicleType.name,
                              typeId: vehicleType.id,
                            ),
                          ),
                        );
                      },
                      iconPrv: "null",
                      label: vehicleType.name,
                    );
                  }),
                  if (showSeeAllButton)
                    Center(
                      child: GestureDetector(
                        onTap: _toggleShowAll,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _showAll
                                    ? "See Less (${vehicleTypes.length - _initialDisplayCount} hidden)"
                                    : "See All (${vehicleTypes.length - _initialDisplayCount} more)",
                                style: AppStyles.medium14(context).copyWith(
                                  color: context.theme.blue100_1,
                                ),
                              ),
                              const Gap(4),
                              Icon(
                                _showAll
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: context.theme.blue100_1,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const Gap(10),
                ],
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
