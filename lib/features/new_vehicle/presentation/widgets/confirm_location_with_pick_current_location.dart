import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmLocationWithPickCurrentLocation extends StatelessWidget {
  const ConfirmLocationWithPickCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapLocationCubit, MapLocationState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'pickCurrentLocation', // Unique hero tag
              backgroundColor: AppColors.myBlue100_8,
              onPressed: () =>
                  context.read<MapLocationCubit>().getCurrentLocation(),
              child: Icon(
                Icons.my_location,
                color: AppColors.myBlue100_1,
              ),
            ),
            FloatingActionButton(
              heroTag: 'confirmLocation', // Unique hero tag
              onPressed: () {
                final locationData =
                    context.read<MapLocationCubit>().getSelectedLocationData();
                if (locationData.isNotEmpty) {
                  Navigator.pop(context, locationData);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a location first'),
                    ),
                  );
                }
              },
              child: const Icon(Icons.check), // Added an icon for better UX
            ),
          ],
        );
      },
    );
  }
}
