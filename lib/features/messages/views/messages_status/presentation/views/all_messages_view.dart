import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/chat_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../model/dummy.dart';
import '../../../personal_chat/presentation/views/personal_chat_view.dart';

class AllMessagesView extends StatefulWidget {
  const AllMessagesView({super.key});

  @override
  State<AllMessagesView> createState() => _AllMessagesViewState();
}

class _AllMessagesViewState extends State<AllMessagesView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MessageCubit>().getMyChat(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6ImQ0YWRmMTdhLTdkYTYtNGYxNC05M2IzLWI5MmRhYTU1NzA0ZCIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTc5NjIzOSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.wUQg22Y0wbSIgGD1ELjsXAAG-5MuKgNPUNfVcXpVeeU");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      builder: (context, state) {
        if (state is MessageSuccess) {
          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            itemCount: state.chats!.data.length,
            itemBuilder: (context, index) {
              DateTime messageTime =
                  DateTime.parse(state.chats!.data[index].lastMessage.sentAt);
              String period = messageTime.hour >= 12 ? 'PM' : 'AM';
              int hour12 = messageTime.hour % 12;
              if (hour12 == 0) hour12 = 12;
              String hoursAndMinutes =
                  "${hour12.toString()}:${messageTime.minute.toString().padLeft(2, '0')} $period";
              return ChatPerson(
                onTap: () {
                  context.read<MessageCubit>().getMessages(
                      state.chats!.data[index].user.id.toString(),
                      "2025-06-03T09:49:51.7950956",
                      "30",
                      "0",
                      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6ImQ0YWRmMTdhLTdkYTYtNGYxNC05M2IzLWI5MmRhYTU1NzA0ZCIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTc5NjIzOSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.wUQg22Y0wbSIgGD1ELjsXAAG-5MuKgNPUNfVcXpVeeU");
                  if (state.messages != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalChatView(
                          messageList: state.messages!.data,
                        ),
                      ),
                    );
                  }
                },
                name: state.chats!.data[index].user.name,
                msg: state.chats!.data[index].lastMessage.content ??
                    state.chats!.data[index].lastMessage.filePath!,
                time: hoursAndMinutes,
                numberMsg: state.chats!.data[index].unseenMessageIds.length,
                image: AppAssets.assetsImagesDafaultPfp,
                //TODO: change it later
              );
            },
          );
        } else if (state is MessageFailure) {
          print(state.errorMessage);
        }
        return const SizedBox();
      },
    );
  }
}
