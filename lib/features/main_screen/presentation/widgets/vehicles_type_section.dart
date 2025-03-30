import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/main_screen/presentation/widgets/vehicle_type_card_net_work_image.dart';
import 'package:aggar/features/main_screen/presentation/cubit/vehicle_type/vehicle_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class VehiclesTypeSection extends StatefulWidget {
  const VehiclesTypeSection({super.key});

  @override
  State<VehiclesTypeSection> createState() => _VehiclesTypeSectionState();
}

class _VehiclesTypeSectionState extends State<VehiclesTypeSection> {
  @override
  void initState() {
    context.read<VehicleTypeCubit>().fetchVehicleTypes(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYwIiwianRpIjoiODAwYWFkYTktYWU0ZS00OGViLTllOGUtY2FlYzdiYmNmZmUwIiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMSIsInVpZCI6IjEwNjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0MzM1NjQ5MCwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.umzyAFQ25uvEfoVQdzzDafEWpggwu2inEgcVareibb0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicles Type",
          style: AppStyles.bold24(context).copyWith(
            color: AppLightColors.myBlue100_5,
          ),
        ),
        const Gap(8),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ListView.builder(
            itemBuilder: (context, index) => VehicleTypeCardNetWorkImage(
              iconPrv: context
                  .read<VehicleTypeCubit>()
                  .vehicleTypeSlogenPaths[index],
              label: context.read<VehicleTypeCubit>().vehicleTypes[index],
            ),
            itemCount: context.read<VehicleTypeCubit>().vehicleTypes.length,
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}
