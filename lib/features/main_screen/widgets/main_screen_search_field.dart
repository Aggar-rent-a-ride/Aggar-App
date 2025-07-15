import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:aggar/features/search/presentation/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenSearchField extends StatelessWidget {
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const MainScreenSearchField({
    super.key,
    this.onTap,
    this.controller,
    this.onChanged,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.white100_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        focusNode: focusNode,
        onTap: onTap == null
            ? () {
                context.read<SearchCubit>().clearBrandFilter();
                context.read<SearchCubit>().clearNearestFilter();
                context.read<SearchCubit>().clearPricingFilter();
                context.read<SearchCubit>().clearRateFilter();
                context.read<SearchCubit>().clearSearch();
                context.read<SearchCubit>().clearStatusFilter();
                context.read<SearchCubit>().clearTransmissionFilter();
                context.read<SearchCubit>().clearTypeFilter();
                context.read<SearchCubit>().clearYearFilter();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      context.read<SearchCubit>().fetchSearch(pageNo: 1);
                      return const SearchScreen();
                    },
                  ),
                );
              }
            : null,
        decoration: InputDecoration(
          hintText: "search",
          hintStyle: AppStyles.regular18(context).copyWith(
            color: context.theme.black100.withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.theme.black100.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
