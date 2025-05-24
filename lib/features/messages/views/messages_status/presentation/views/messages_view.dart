import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/admin_main_cubit/admin_main_state.dart';
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
    return BlocBuilder<AdminMainCubit, AdminMainState>(
        builder: (context, state) {
      if (state is AdminMainConnected) {
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
                onPressed: () {
                  context.read<MessageCubit>().getMyChat(state.accessToken);
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
          body: AllMessagesView(
            accessToken: state.accessToken,
          ),
        );
      } else if (state is AdminMainDisconnected) {
        return Center(
          child: Text(
            'You are not connected to the server',
            style: AppStyles.semiBold20(context)
                .copyWith(color: context.theme.red100_1),
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: context.theme.blue100_1,
          ),
        );
      }
    });
  }
}
