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
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiYmU3YTc0ZTktZmJhYS00N2YxLWEyNzktMjYxZmQ1ZDA4ZDA0IiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0MzY0NTEzNywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.KNJIlZ1O6lk9g7J6m2CmSIVpjGflg8Tr9kE5B80P0Hk");
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
          height: MediaQuery.of(context).size.width * 0.32,
          child: ListView.builder(
            itemBuilder: (context, index) => VehicleBrandCardNetWorkImage(
              numOfBrands: 30,
              imgPrv: context
                  .read<VehicleBrandCubit>()
                  .vehicleBrandLogoPaths[index],
              label: context.read<VehicleBrandCubit>().vehicleBrands[index],
            ),
            itemCount: context.read<VehicleBrandCubit>().vehicleBrands.length,
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}
