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
                child: TextField(
                  controller: context.read<MapLocationCubit>().searchController,
                  decoration: InputDecoration(
                    hintText: 'Search location',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (value) =>
                      context.read<MapLocationCubit>().searchLocation(value),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => context
                    .read<MapLocationCubit>()
                    .searchLocation(
                        context.read<MapLocationCubit>().searchController.text),
              ),
            ],
          ),
        );
      },
    );
  }
}
