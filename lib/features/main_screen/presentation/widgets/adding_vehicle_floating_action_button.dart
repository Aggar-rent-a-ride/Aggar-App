import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/features/new_vehicle/presentation/views/add_vehicle_screen.dart';
import 'package:flutter/material.dart';

class AddingVehicleFloatingActionButton extends StatelessWidget {
  const AddingVehicleFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FloatingActionButton(
          splashColor: AppLightColors.myBlue100_1,
          backgroundColor: AppLightColors.myBlue100_1,
          elevation: 0,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            color: AppLightColors.myWhite100_1,
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddVehicleScreen(),
              ),
            );
          }),
    );
  }
}
