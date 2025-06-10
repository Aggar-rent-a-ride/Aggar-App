import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/view/edit_vehicle_brand_screen.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/add_vehicle_type_or_brand_button.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/vehicle_brand_card_net_work_image_vehilce_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../view/add_vehicle_brand_screen.dart';
import 'loading_vehicle_brand_section.dart';

class VehicleBrandsSection extends StatefulWidget {
  const VehicleBrandsSection({super.key});

  @override
  State<VehicleBrandsSection> createState() => _VehicleBrandsSectionState();
}

class _VehicleBrandsSectionState extends State<VehicleBrandsSection> {
  bool _showAll = false;
  final int _initialDisplayCount = 6;

  void _toggleShowAll() {
    setState(() {
      _showAll = !_showAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminVehicleBrandCubit, AdminVehicleBrandState>(
      builder: (context, state) {
        if (state is AdminVehicleBrandLoading) {
          return const LoadingVehicleBrandSection();
        } else if (state is AdminVehicleBrandLoaded) {
          final vehicleTypes = state.listVehicleBrandModel.data;
          if (vehicleTypes.isEmpty) {
            return Text(
              "No vehicle brands available",
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
                          "Vehicle Brands",
                          style: AppStyles.bold18(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          "${vehicleTypes.length} brands available",
                          style: AppStyles.regular12(context).copyWith(
                            color: context.theme.blue100_1.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AddVehicleTypeOrBrandButton(
                      text: "Add Brand",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddVehicleBrandScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Gap(4),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: displayTypes.length,
                itemBuilder: (context, index) {
                  final vehicleBrand = displayTypes[index];
                  return VehicleBrandCardNetWorkImageVehilceSettings(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditVehicleBrandScreen(
                            brandCountry: vehicleBrand.country,
                            brandImageUrl: vehicleBrand.logoPath ?? "null",
                            brandName: vehicleBrand.name,
                            brandId: vehicleBrand.id,
                          ),
                        ),
                      );
                    },
                    imgPrv: vehicleBrand.logoPath ?? "null",
                    label: vehicleBrand.name,
                  );
                },
              ),
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
              const Gap(16),
            ],
          );
        } else if (state is AdminVehicleBrandError) {
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
