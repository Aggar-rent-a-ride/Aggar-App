import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
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
  String? accessToken;
  bool isLoading = false;
  bool isLoadingToken = true;

  @override
  void initState() {
    super.initState();
    _getValidToken();
  }

  // Get a valid token before loading chats
  Future<void> _getValidToken() async {
    setState(() {
      isLoadingToken = true;
    });

    try {
      final token = await context.read<TokenRefreshCubit>().ensureValidToken();
      if (token != null) {
        setState(() {
          accessToken = token;
          isLoadingToken = false;
        });
        _loadChats();
      } else {
        setState(() {
          isLoadingToken = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Authentication error. Please login again."),
          ),
        );
        // Navigate to login screen or handle authentication error
      }
    } catch (e) {
      setState(() {
        isLoadingToken = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Authentication error: $e"),
        ),
      );
    }
  }

  void _loadChats() {
    if (accessToken != null) {
      context.read<MessageCubit>().getMyChat(accessToken!);
    } else {
      _getValidToken();
    }
  }
  
  Future<void> _ensureValidTokenAndExecute(Function(String token) action) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        final token = await context.read<TokenRefreshCubit>().ensureValidToken();
        
        if (token != null) {
          setState(() {
            accessToken = token;
          });
          action(token);
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Authentication error. Please login again."),
            ),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Authentication error: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                    _ensureValidTokenAndExecute((validToken) {
                      context.read<MessageCubit>().getMessages(
                          state.chats!.data[index].user.id.toString(),
                          "2025-06-03T09:49:51.7950956",
                          "30",
                          "0",
                          validToken);
                    });
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
