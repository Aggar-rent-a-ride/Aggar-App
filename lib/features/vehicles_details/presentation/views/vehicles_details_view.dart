import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class VehiclesDetailsView extends StatelessWidget {
  const VehiclesDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite100_1,
      body: const Column(
        children: [
          CustomAppBar(),
        ],
      ),
    );
  }
}
