import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchForMsgByContentOrDate extends StatelessWidget {
  const SearchForMsgByContentOrDate({super.key, required this.cubit});
  final PersonalChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: context.theme.white100_2,
              cursorOpacityAnimates: true,
              focusNode: FocusNode(),
              onSubmitted: (value) async {
                final tokenCubit = context.read<TokenRefreshCubit>();
                final token = await tokenCubit.getAccessToken();
                if (token != null) {
                  cubit.filterMessages(token);
                }
              },
              controller: cubit.searchController,
              autofocus: true,
              style: AppStyles.medium16(context).copyWith(
                color: context.theme.white100_2,
              ),
              decoration: InputDecoration(
                hintText: cubit.dateSelected
                    ? cubit.dateController.text
                    : "Search messages...",
                hintStyle: AppStyles.medium16(context).copyWith(
                  color: context.theme.white100_1.withOpacity(0.6),
                ),
                border: InputBorder.none,
                suffixText: cubit.searchResultMessageIds.isNotEmpty
                    ? "${cubit.currentHighlightIndex + 1}/${cubit.searchResultMessageIds.length}"
                    : null,
                suffixStyle: AppStyles.regular14(context).copyWith(
                  color: context.theme.white100_1,
                ),
              ),
              onChanged: (value) {
                if (cubit.dateSelected) {
                  cubit.dateSelected = false;
                  cubit.dateController.clear();
                }
                cubit.updateSearchQuery(value);
              },
            ),
          ),
          if (cubit.searchResultMessageIds.isNotEmpty) ...[
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_up,
                color: context.theme.white100_2,
              ),
              onPressed: () {
                cubit.goToPreviousSearchResult();
              },
              tooltip: 'Previous match',
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              padding: const EdgeInsets.all(4),
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: context.theme.white100_2,
              ),
              onPressed: () {
                cubit.goToNextSearchResult();
              },
              tooltip: 'Next match',
              constraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ],
      ),
    );
  }
}
