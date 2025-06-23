import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/see_more_button.dart';
import 'package:aggar/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:aggar/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:aggar/features/profile/presentation/views/favorite_vehicle_screen.dart';
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
                        color: context.theme.gray100_2,
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
                        (entry) => Card(
                          elevation: 0.5,
                          color: context.theme.white100_1,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                "${EndPoint.baseUrl}${entry.value.mainImagePath}",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.error,
                                  color: context.theme.gray100_2,
                                ),
                              ),
                            ),
                            title: Text(
                              '${entry.value.brand} ${entry.value.model}',
                              style: AppStyles.bold16(context),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.value.year} • ${entry.value.transmission}',
                                  style: AppStyles.medium14(context).copyWith(
                                    color: context.theme.gray100_2,
                                  ),
                                ),
                                Text(
                                  '\$${entry.value.pricePerDay.toStringAsFixed(2)}/day',
                                  style: AppStyles.medium14(context).copyWith(
                                    color: context.theme.blue100_2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                  color: context.theme.gray100_2,
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
                    color: context.theme.gray100_2,
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
