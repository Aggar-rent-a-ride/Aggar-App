import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/chat_person.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/personal_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllMessagesView extends StatelessWidget {
  const AllMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageCubit, MessageState>(
      listener: (context, state) {
        if (state is MessageSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<MessageCubit>(),
                child: PersonalChatView(
                  messageList: state.messages!.data,
                  receiverId: state.userId!,
                  receiverName: state.receiverName,
                ),
              ),
            ),
          );
        } else if (state is MessageFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is ChatSuccess) {
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.chats!.data.length,
              itemBuilder: (context, index) {
                final chatData = state.chats!.data[index];
                DateTime messageTime =
                    DateTime.parse('${chatData.lastMessage.sentAt}Z').toLocal();
                String period = messageTime.hour >= 12 ? 'PM' : 'AM';
                int hour12 =
                    messageTime.hour % 12 == 0 ? 12 : messageTime.hour % 12;
                String hoursAndMinutes =
                    "$hour12:${messageTime.minute.toString().padLeft(2, '0')} $period";
                return ChatPerson(
                  onTap: () {
                    context.read<MessageCubit>().getMessages(
                          userId: chatData.user.id.toString(),
                          dateTime: DateTime.now().toUtc().toIso8601String(),
                          pageSize: "20",
                          dateFilter: "0",
                          accessToken:
                              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMSIsImp0aSI6IjcxZTUyOWQ4LWVhY2YtNDI3Yy05OGM3LTVkMGEyYTE2MWU0MSIsInVzZXJuYW1lIjoibmFydSIsInVpZCI6IjExIiwicm9sZXMiOlsiQWRtaW4iLCJVc2VyIl0sImV4cCI6MTc0ODEwMjQ3MCwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.dtMsIOVPACfIrr4rocj8YsI3Rtlg5ygj2EE6-r1yiLY",
                          receiverName: chatData.user.name,
                        );
                  },
                  name: chatData.user.name,
                  msg: chatData.lastMessage.content ??
                      chatData.lastMessage.filePath ??
                      "No message",
                  time: hoursAndMinutes,
                  numberMsg: chatData.unseenMessageIds.length,
                  image: chatData.user.imagePath,
                );
              },
            ),
          );
        } else if (state is ChatsLoading || state is MessageLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessageFailure) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
