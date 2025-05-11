import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/main_screen/presentation/cubit/search_field/search_state.dart';
import 'package:aggar/features/main_screen/presentation/widgets/brand_filter_chip.dart';
import 'package:aggar/features/main_screen/presentation/widgets/filter_icon.dart';
import 'package:aggar/features/main_screen/presentation/widgets/nearest_filter_chip.dart';
import 'package:aggar/features/main_screen/presentation/widgets/pricing_filter_chip.dart';
import 'package:aggar/features/main_screen/presentation/widgets/rating_filter_chip.dart';
import 'package:aggar/features/main_screen/presentation/widgets/rescent_search.dart';
import 'package:aggar/features/main_screen/presentation/widgets/search_field_navigation.dart';
import 'package:aggar/features/main_screen/presentation/widgets/search_result_section.dart';
import 'package:aggar/features/main_screen/presentation/widgets/transmission_filter_chip.dart';
import 'package:aggar/features/main_screen/presentation/widgets/type_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isNearestSelected = false;
  bool isTypeSelected = false;
  bool isBrandSelected = false;
  bool isPriceSelected = false;
  bool isTransmissionSelected = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return BlocBuilder<SearchCubit, SearchCubitState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.theme.white100_1,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.theme.blue100_8,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 55,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SearchFieldNavigation(cubit: cubit),
                        const Gap(10),
                        FilterIcon(
                          onPressed: cubit.toggleFilterVisibility,
                        ),
                      ],
                    ),
                    const Gap(10),
                    if (cubit.isFilterVisible)
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 10,
                          children: [
                            NearestFilterChip(),
                            TypeFilterChip(),
                            BrandFilterChip(),
                            TransmissionFilterChip(),
                            RatingFilterChip(),
                            PricingFilterChip(),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              Expanded(
                child: cubit.query.isEmpty
                    ? const RescentSearch()
                    : const SearchResultSection(),
              ),
            ],
          ),
        );
      },
    );
  }
}
