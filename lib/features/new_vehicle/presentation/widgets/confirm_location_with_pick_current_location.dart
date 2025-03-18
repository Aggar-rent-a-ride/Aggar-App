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
        return Positioned(
          right: 25,
          bottom: MediaQuery.sizeOf(context).height * 0.21,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                ),
                heroTag: 'pickCurrentLocation',
                backgroundColor: AppColors.myBlue100_1,
                onPressed: () =>
                    context.read<MapLocationCubit>().getCurrentLocation(),
                child: Icon(
                  Icons.my_location,
                  color: AppColors.myWhite100_1,
                ),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                ),
                heroTag: 'confirmLocation',
                backgroundColor: AppColors.myBlue100_1,
                onPressed: () {
                  final locationData = context
                      .read<MapLocationCubit>()
                      .getSelectedLocationData();
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
                child: Icon(
                  Icons.check,
                  color: AppColors.myWhite100_1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
