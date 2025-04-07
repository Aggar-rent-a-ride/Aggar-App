import 'package:aggar/core/themes/app_light_colors.dart';

import 'package:aggar/features/main_screen/presentation/widgets/vehicle_brand_card_net_work_image.dart';

import 'package:aggar/features/main_screen/presentation/cubit/vehicle_brand/vehicle_brand_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/app_styles.dart';

class BrandsSection extends StatefulWidget {
  const BrandsSection({super.key});

  @override
  State<BrandsSection> createState() => _BrandsSectionState();
}

class _BrandsSectionState extends State<BrandsSection> {
  @override
  void initState() {
    context.read<VehicleBrandCubit>().fetchVehicleBrands(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiMTU3NWYwZjMtZWJjMy00NGE0LWE3M2MtMDE5MTJhOWYxOWE3IiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NDA2NDQyMiwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.pn0xktKVIaxuMv2NUsmq_guqbJvZ7eU63PBTzaVlcrg");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brands",
          style: AppStyles.bold24(context).copyWith(
            color: AppLightColors.myBlue100_5,
          ),
        ),
        const Gap(5),
        SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
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
              );
            },
          ),
        )
      ],
    );
  }
}
