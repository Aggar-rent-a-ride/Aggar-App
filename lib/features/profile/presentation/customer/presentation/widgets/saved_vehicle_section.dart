import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_cubit.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/cubit/profile/profile_state.dart';
import 'package:aggar/features/profile/presentation/customer/presentation/views/favorite_vehicle_screen.dart';
import 'package:aggar/features/profile/presentation/renter/presentation/widgets/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedVehicleSection extends StatelessWidget {
  const SavedVehicleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileGetFavoriteSuccess) {
          final vehicles = state.listVehicleModel.data.take(10).toList();
          if (vehicles.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite,
                        size: 50, color: context.theme.blue100_2),
                    const SizedBox(height: 10),
                    Text(
                      'No saved vehicles yet',
                      style: AppStyles.medium16(context).copyWith(
                        color: context.theme.black50,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: vehicles
                      .asMap()
                      .entries
                      .map(
                        (entry) => VehicleCard(entry: entry),
                      )
                      .toList(),
                ),
                SeeMoreButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteVehicleScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        } else if (state is ProfileError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: AppStyles.medium16(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 50, color: context.theme.blue100_2),
                const SizedBox(height: 10),
                Text(
                  'No saved vehicles yet',
                  style: AppStyles.medium16(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
