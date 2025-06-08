import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/vehicle_brand_card_net_work_image.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_cubit.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/cubit/admin_vehilce_brand/admin_vehicle_brand_state.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/view/add_vehicle_brand_screen.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/view/edit_vehicle_brand_screen.dart';
import 'package:aggar/features/vehicle_brand_with_type/presentation/widgets/add_vehicle_type_or_brand_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class VehicleBrandsSection extends StatefulWidget {
  const VehicleBrandsSection({super.key});

  @override
  State<VehicleBrandsSection> createState() => _VehicleBrandsSectionState();
}

class _VehicleBrandsSectionState extends State<VehicleBrandsSection> {
  bool _showAll = false;
  final int _initialDisplayCount = 5;

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
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.theme.blue100_1,
                  ),
                ),
                const Gap(10),
                Text(
                  "Loading brands...",
                  style: AppStyles.regular14(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ],
            ),
          );
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
                child: Text(
                  "Vehicle Brands",
                  style: AppStyles.bold18(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ),
              Wrap(
                runSpacing: 5,
                children: [
                  ...displayTypes.map((vehicleBrand) {
                    return VehicleBrandCardNetWorkImage(
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
              AddVehicleTypeOrBrandButton(
                text: "Add Vehicle Brand",
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
