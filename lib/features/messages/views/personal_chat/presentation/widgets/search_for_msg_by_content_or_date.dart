import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_cubit.dart';
import 'package:flutter/material.dart';

class SearchForMsgByContentOrDate extends StatelessWidget {
  const SearchForMsgByContentOrDate({super.key, required this.cubit});
  final PersonalChatCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: context.theme.white100_2,
      cursorOpacityAnimates: true,
      focusNode: FocusNode(),
      onSubmitted: (value) {
        cubit.filtterMessage(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6IjAwN2M3MWQyLThkMTAtNGZmYi1iZjQ3LTAwNTQ5OThmMjc1MiIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NjE5MDQ4NSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.tn-I81zexgiOcTeziQ-NxH-D8K1Qx0n3n3RWrM2L7eQ");
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
      ),
      onChanged: (value) {
        if (cubit.dateSelected) {
          cubit.dateSelected = false;
          cubit.dateController.clear();
        }
        cubit.updateSearchQuery(value);
      },
    );
  }
}
