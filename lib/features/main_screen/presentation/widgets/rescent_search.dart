import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RescentSearch extends StatelessWidget {
  const RescentSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: AppStyles.medium18(context),
          ),
          const Gap(16),
          Expanded(
            child: cubit.recentSearches.isEmpty
                ? const Center(child: Text('No recent searches'))
                : ListView.separated(
                    itemCount: cubit.recentSearches.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final recentSearch = cubit.recentSearches[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history),
                        title: Text(recentSearch),
                        trailing: IconButton(
                          icon: const Icon(Icons.north_west),
                          onPressed: () {
                            cubit.selectRecentSearch(recentSearch);
                          },
                        ),
                        onTap: () {
                          cubit.selectRecentSearch(recentSearch);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
