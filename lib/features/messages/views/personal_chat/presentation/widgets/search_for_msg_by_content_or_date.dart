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
      onSubmitted: (value) {
        cubit.filtterMessage(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6IjgwNzNmZGJlLWVhMjEtNDQzNi1hYzg4LWE0MjE5OGIyMGM4OSIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTY5NzE5NywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.6X8RMAOnWtrI8UQbPK_NQCk9bbxNJJFXT46uSM27SqQ");
      },
      controller: cubit.searchController,
      autofocus: true,
      style: AppStyles.medium16(context).copyWith(
        color: context.theme.white100_2,
      ),
      decoration: InputDecoration(
        hintText: "Search messages...",
        hintStyle: AppStyles.medium16(context).copyWith(
          color: context.theme.white100_1.withOpacity(0.6),
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        cubit.updateSearchQuery(value);
      },
    );
  }
}
