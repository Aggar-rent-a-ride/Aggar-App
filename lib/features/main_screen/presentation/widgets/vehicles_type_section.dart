import 'package:aggar/core/extensions/context_colors_extension.dart';
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
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiNjU3NDc2YjgtMjA3Ny00M2I4LWEzM2ItZTE4ZGM5NDE0ODUwIiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NDkxNDE0MywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.4sWcih_FErqemrfAK25qRcP8niMa2Pj-apDyZewqlKk");
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
            color: context.theme.blue100_5,
          ),
        ),
        const Gap(8),
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  context.read<VehicleTypeCubit>().vehicleTypes.length,
                  (index) => VehicleTypeCardNetWorkImage(
                    iconPrv: context
                        .read<VehicleTypeCubit>()
                        .vehicleTypeSlogenPaths[index],
                    label: context.read<VehicleTypeCubit>().vehicleTypes[index],
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
