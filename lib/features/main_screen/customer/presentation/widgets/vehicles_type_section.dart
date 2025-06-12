import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/vehicle_type_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/vehicle_type_card_net_work_image.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/utils/app_styles.dart';

class VehiclesTypeSection extends StatelessWidget {
  const VehiclesTypeSection({super.key});
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicles Type",
          style: AppStyles.bold24(context).copyWith(
            color: context.theme.blue100_5,
          ),
        ),
        const Gap(8),
        LayoutBuilder(
          builder: (context, constraints) {
            return RawScrollbar(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.36,
              ),
              thumbVisibility: true,
              minThumbLength: MediaQuery.sizeOf(context).width * 0.1,
              trackVisibility: true,
              trackRadius: const Radius.circular(50),
              trackColor: context.theme.gray100_1,
              controller: scrollController,
              thumbColor: context.theme.blue100_5,
              radius: const Radius.circular(20),
              thickness: 8,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      context.read<VehicleTypeCubit>().vehicleTypes.length,
                      (index) => VehicleTypeCardNetWorkImage(
                        onTap: () {
                          final vehicleTypesList =
                              context.read<VehicleTypeCubit>().vehicleTypes;
                          final mainState = context.read<MainCubit>().state;
                          if (mainState is MainConnected) {
                            final accessToken = mainState.accessToken;
                            final typeIds =
                                context.read<VehicleTypeCubit>().vehicleTypeIds;
                            print(typeIds);
                            print(vehicleTypesList);
                            print(typeIds);
                            print(vehicleTypesList[index]);
                            print(typeIds);
                            print(typeIds[index]);
                            if (index < typeIds.length) {
                              context.read<VehicleTypeCubit>().fetchVehicleType(
                                    accessToken,
                                    typeIds[index],
                                  );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VehicleTypeScreen(
                                    selectedTypeId: typeIds[index],
                                    selectedTypeString: vehicleTypesList[index],
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        iconPrv: context
                            .read<VehicleTypeCubit>()
                            .vehicleTypeSlogenPaths[index],
                        label: context
                            .read<VehicleTypeCubit>()
                            .vehicleTypes[index],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
