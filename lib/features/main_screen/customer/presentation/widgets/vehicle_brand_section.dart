import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_cubit.dart';
import 'package:aggar/features/main_screen/customer/presentation/cubit/main_screen/main_screen_state.dart';
import 'package:aggar/features/main_screen/customer/presentation/views/vehicle_brand_screen.dart';
import 'package:aggar/features/main_screen/customer/presentation/widgets/vehicle_brand_card_net_work_image.dart';

import 'package:aggar/features/main_screen/customer/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../core/utils/app_styles.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brands",
          style: AppStyles.bold24(context).copyWith(
            color: context.theme.blue100_5,
          ),
        ),
        const Gap(5),
        SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return RawScrollbar(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.36,
                ),
                thumbVisibility: true,
                minThumbLength: MediaQuery.sizeOf(context).width * 0.1,
                trackVisibility: true,
                trackRadius: const Radius.circular(50),
                trackColor: context.theme.grey100_1,
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
                        context.read<VehicleBrandCubit>().vehicleBrands.length,
                        (index) => VehicleBrandCardNetWorkImage(
                          onTap: () {
                            final vehicleBrandsList =
                                context.read<VehicleBrandCubit>().vehicleBrands;
                            final mainState = context.read<MainCubit>().state;
                            if (mainState is MainConnected) {
                              final accessToken = mainState.accessToken;
                              final typeIds = context
                                  .read<VehicleBrandCubit>()
                                  .vehicleBrandIds;
                              if (index < typeIds.length) {
                                context
                                    .read<VehicleBrandCubit>()
                                    .fetchVehicleBrand(
                                        accessToken, typeIds[index]);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VehicleBrandScreen(
                                      selectedBrandId: typeIds[index],
                                      selectedBrandString:
                                          vehicleBrandsList[index],
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          imgPrv: context
                              .read<VehicleBrandCubit>()
                              .vehicleBrandLogoPaths[index],
                          label: context
                              .read<VehicleBrandCubit>()
                              .vehicleBrands[index],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
