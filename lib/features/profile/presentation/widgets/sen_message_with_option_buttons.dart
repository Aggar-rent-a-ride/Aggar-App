import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/show_model_bottom_sheet.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/ban_list_tile_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/delete_list_tile_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/warning_list_tile_button.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/personal_chat_view.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SenMessageWithOptionButtons extends StatelessWidget {
  const SenMessageWithOptionButtons({
    super.key,
    required this.user,
    this.isAdmin = false,
  });
  final UserModel user;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocListener<MessageCubit, MessageState>(
          listener: (context, state) {
            if (state is MessageSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalChatView(
                    messageList: state.messages!.data,
                    receiverId: user.id,
                    receiverName: user.name,
                    reciverImg: user.imagePath,
                    onMessagesUpdated: () {},
                  ),
                ),
              );
            }
          },
          child: ElevatedButton(
            onPressed: () async {
              final tokenCubit = context.read<TokenRefreshCubit>();
              final token = await tokenCubit.ensureValidToken();
              if (token != null) {
                final messageCubit = context.read<MessageCubit>();
                await messageCubit.getMessages(
                  userId: user.id.toString(),
                  dateTime: DateTime.now().toUtc().toIso8601String(),
                  pageSize: "20",
                  dateFilter: "0",
                  accessToken: token,
                  receiverName: user.name,
                  receiverImg: user.imagePath,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              overlayColor: context.theme.blue100_1.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
              backgroundColor: context.theme.white100_1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: context.theme.black25, width: 1),
              ),
            ),
            child: Text(
              'Send a Message',
              style: AppStyles.medium18(
                context,
              ).copyWith(color: context.theme.black50),
            ),
          ),
        ),
        if (isAdmin == true)
          ElevatedButton(
            onPressed: () async {
              final tokenCubit = context.read<TokenRefreshCubit>();
              final token = await tokenCubit.ensureValidToken();
              if (token != null) {
                customShowModelBottmSheet(
                  context,
                  "Options",
                  Column(
                    children: [
                      WarningListTileButton(user: user, accessToken: token),
                      BanListTileButton(user: user, accessToken: token),
                      DeleteListTileButton(user: user, accessToken: token),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              overlayColor: context.theme.blue100_1.withOpacity(0.1),
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: context.theme.white100_1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: context.theme.black25, width: 1),
              ),
              fixedSize: const Size(44, 44),
            ),
            child: Icon(
              Icons.more_vert_rounded,
              color: context.theme.black50,
              size: 26,
            ),
          ),
      ],
    );
  }
}
