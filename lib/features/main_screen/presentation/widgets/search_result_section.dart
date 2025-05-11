import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SearchResultSection extends StatelessWidget {
  const SearchResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return BlocBuilder<SearchCubit, SearchCubitState>(
      builder: (context, state) {
        if (state is SearchCubitLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchCubitError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is SearchCubitEmpty || cubit.searchResults.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Results',
                style: AppStyles.medium18(context),
              ),
              const Gap(16),
              Expanded(
                child: ListView.separated(
                  itemCount: cubit.searchResults.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final result = cubit.searchResults[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.search),
                      title: Text(result),
                      onTap: () {
                        cubit.saveRecentSearch(cubit.query);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
