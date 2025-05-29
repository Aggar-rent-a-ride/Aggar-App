import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/all_messages_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/app_styles.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        title: Text(
          'Messages',
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final tokenCubit = context.read<TokenRefreshCubit>();
              final token = await tokenCubit.getAccessToken();
              if (token != null) context.read<MessageCubit>().getMyChat(token);
            },
            icon: Icon(
              Icons.search,
              color: context.theme.black50,
            ),
          ),
          const Gap(20),
        ],
      ),
      backgroundColor: context.theme.white100_1,
      body: const AllMessagesView(),
    );
  }
}
