import 'package:aggar/core/extensions/context_colors_extension.dart';

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
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDYzIiwianRpIjoiYmViMzU2ZGItYTI0MS00NGNlLTk4NDQtMTRhMmJiM2EwM2YzIiwidXNlcm5hbWUiOiJlc3JhYXRlc3QxMiIsInVpZCI6IjEwNjMiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTE2MDQ5MSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.m5oSbL6WKHNjEjzE856CB14yBGnY2h4oUTyz8NT_smg");
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
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
                controller: _scrollController,
                thumbColor: context.theme.blue100_5,
                radius: const Radius.circular(20),
                thickness: 8,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SingleChildScrollView(
                    controller: _scrollController,
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
