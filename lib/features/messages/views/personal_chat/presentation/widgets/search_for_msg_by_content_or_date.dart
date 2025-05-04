import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_cubit.dart';
import 'package:flutter/material.dart';

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
              onSubmitted: (value) {
                cubit.filtterMessage(
                    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6IjEwMjdmNjgzLTM5MzQtNDAwMi1hN2Y5LWEyMWVlODNiMjJhZiIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NjM4OTQwNCwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.vkaBVT5rgAEQ-YTs7TjFRMI1TerfmYGVyeD_JjiWYok");
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
