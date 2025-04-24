import 'package:aggar/core/extensions/context_colors_extension.dart';

import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_card_net_work_image.dart';

import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';

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
                // TODO : make them dynamic numbers
                padding: const EdgeInsets.symmetric(horizontal: 160),
                thumbVisibility: true,
                minThumbLength: 65,
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
                    // TODO : make them dynamic numbers
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        context.read<VehicleBrandCubit>().vehicleBrands.length,
                        (index) => VehicleBrandCardNetWorkImage(
                          numOfBrands: 30,
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
