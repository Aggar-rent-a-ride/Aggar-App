import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/map_location/map_location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressSearchBar extends StatelessWidget {
  const AddressSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapLocationCubit, MapLocationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 0),
                      blurRadius: 4,
                      color: AppColors.myBlack25,
                    )
                  ],
                ),
                child: TextField(
                  controller: context.read<MapLocationCubit>().searchController,
                  decoration: InputDecoration(
                    fillColor: AppColors.myWhite100_1,
                    filled: true,
                    hintText: 'Search location',
                    hintStyle: AppStyles.regular15(context).copyWith(
                      color: AppColors.myBlack50,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.myBlack10,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.myBlue100_2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.myBlack10,
                      ),
                    ),
                  ),
                  onSubmitted: (value) =>
                      context.read<MapLocationCubit>().searchLocation(value),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}
