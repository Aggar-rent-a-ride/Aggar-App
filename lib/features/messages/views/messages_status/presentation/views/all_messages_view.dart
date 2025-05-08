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

class _AllMessagesViewState extends State<AllMessagesView>
    with AutomaticKeepAliveClientMixin {
  String? accessToken;
  bool isLoading = false;
  bool isLoadingToken = true;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getValidToken();
    });
  }

  // Get a valid token before loading chats
  Future<void> _getValidToken() async {
    setState(() {
      isLoadingToken = true;
    });

    try {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final token = await tokenCubit.ensureValidToken();

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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Authentication error. Please login again."),
            ),
          );
        }
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

  Future<void> _ensureValidTokenAndExecute(
      Function(String token) action) async {
    if (!mounted || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final tokenCubit = context.read<TokenRefreshCubit>();
      final token = await tokenCubit.ensureValidToken();
      if (token != null) {
        setState(() {
          accessToken = token;
        });
        action(token);
      } else {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Authentication error. Please login again."),
            ),
          );
        }
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

  void _handleChatTap(String userId, String dateTime) {
    if (!mounted) return;

    _ensureValidTokenAndExecute((validToken) {
      if (!mounted) return;

      final messageCubit = context.read<MessageCubit>();
      messageCubit.getMessages(
        userId,
        dateTime,
        "20",
        "0",
        validToken,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          final messageData = state.messages!.data;
          final int receiverId = state.userId ?? 0;
          print('Opening PersonalChatView with receiverId: $receiverId');
          Future.microtask(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PersonalChatView(
                  messageList: messageData,
                  receiverId: receiverId,
                  onMessagesUpdated: () {
                    if (mounted) _loadChats();
                  },
                ),
              ),
            );
          });
        } else if (state is MessageFailure && isLoading) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to load messages: ${state.errorMessage}"),
            ),
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
              final chatData = state.chats!.data[index];
              DateTime messageTime =
                  DateTime.parse('${chatData.lastMessage.sentAt}Z').toLocal();
              String period = messageTime.hour >= 12 ? 'PM' : 'AM';
              int hour12 = messageTime.hour % 12;
              if (hour12 == 0) hour12 = 12;
              String hoursAndMinutes =
                  "${hour12.toString()}:${messageTime.minute.toString().padLeft(2, '0')} $period";

              return ChatPerson(
                /*<<<<<<< esraa
                  onTap: () {
                    if (!isLoading) {
                      setState(() {
                        isLoading = true;
                      });
                      context.read<PersonalChatCubit>().markAsSeen(
                          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6Ijk1NDUxMDhiLTRjMzMtNGNlOS1hZjZkLTUxMjQ2MTIxNTQyMyIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTg3ODA5NywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.k643dikDe_qL55CtKZ5XGbV-8ymEg6YLmwfZqMvUFd0",
                          [26]);
                    }
                  },
                
=======*/
                onTap: () => _handleChatTap(
                  chatData.user.id.toString(),
                  "2025-06-03T09:49:51.7950956",
                ),
                name: chatData.user.name,
                msg: chatData.lastMessage.content ??
                    chatData.lastMessage.filePath!,
                time: hoursAndMinutes,
                numberMsg: chatData.unseenMessageIds.length,
                image: chatData.user.imagePath,
              );
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
