import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/chat_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../personal_chat/presentation/views/personal_chat_view.dart';

class AllMessagesView extends StatefulWidget {
  const AllMessagesView({super.key});
  @override
  State<AllMessagesView> createState() => _AllMessagesViewState();
}

class _AllMessagesViewState extends State<AllMessagesView> {
  final String accessToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6ImY4YTFmNzZkLTY2OWItNDQ2NS1iZTQ5LTVlYTFlNDc4MjY5YSIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTg3MzU1OSwiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.4xMYowj7oMWKMlPUlmwpybGXG5qaKoI6e_Ed_mXpDoc";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() {
    context.read<MessageCubit>().getMyChat(accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageCubit, MessageState>(
      listener: (context, state) {
        if (state is MessageSuccess && isLoading) {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonalChatView(
                messageList: state.messages!.data,
              ),
            ),
          ).then((_) {
            _loadChats();
          });
        } else if (state is MessageFailure && isLoading) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Failed to load messages: ${state.errorMessage}")),
          );
        }
      },
      builder: (context, state) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ChatSuccess) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
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
                    if (!isLoading) {
                      setState(() {
                        isLoading = true;
                      });

                      context.read<MessageCubit>().getMessages(
                          state.chats!.data[index].user.id.toString(),
                          "2025-06-03T09:49:51.7950956",
                          "30",
                          "0",
                          accessToken);
                    }
                  },
                  name: state.chats!.data[index].user.name,
                  msg: state.chats!.data[index].lastMessage.content ??
                      state.chats!.data[index].lastMessage.filePath!,
                  time: hoursAndMinutes,
                  numberMsg: state.chats!.data[index].unseenMessageIds.length,
                  image: state.chats!.data[index].user.imagePath);
            },
          );
        } else if (state is ChatsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessageFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${state.errorMessage}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadChats,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
