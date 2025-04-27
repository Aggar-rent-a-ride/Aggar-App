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
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6ImRhOTc5MTFmLWE2NjMtNDkxMC05MjViLWM3ZTJjODRiZGM0MSIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTc3NzIzMywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.Zs4aV0hobG97UG9vazg_sLW-Khdo92uRmcDPp9tlGVw");
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
