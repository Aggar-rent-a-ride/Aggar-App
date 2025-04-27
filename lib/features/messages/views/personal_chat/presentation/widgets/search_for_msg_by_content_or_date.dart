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
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6ImE3ZDg5NTYyLWJmNTctNGIwNS1hMDQ4LTNkNzY2MWYwMTQ3ZCIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTc0NzE1OSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.-3-2mJBytmcjve30TIQcedMVJaX3pbIU1bL2WNKbwLY");
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
