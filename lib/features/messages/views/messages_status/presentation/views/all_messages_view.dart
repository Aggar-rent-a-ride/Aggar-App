import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_chat_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/chat_person.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/personal_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllMessagesView extends StatefulWidget {
  const AllMessagesView({super.key});

  @override
  _AllMessagesViewState createState() => _AllMessagesViewState();
}

class _AllMessagesViewState extends State<AllMessagesView>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late MessageCubit _messageCubit;
  late TokenRefreshCubit _tokenRefreshCubit;
  bool _isViewActive = true;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _messageCubit = context.read<MessageCubit>();
    _tokenRefreshCubit = context.read<TokenRefreshCubit>();
    WidgetsBinding.instance.addObserver(this);
    _startPollingWithToken();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        _loadMoreChats();
      }
    });
  }

  Future<void> _startPollingWithToken() async {
    if (!_isViewActive || !mounted) return;
    final token = await _tokenRefreshCubit.getAccessToken();
    if (token != null && mounted) {
      _messageCubit.startPolling(token, isViewActive: true);
    }
  }

  Future<void> _loadMoreChats() async {
    if (!mounted) return;
    final token = await _tokenRefreshCubit.getAccessToken();
    if (token != null) {
      await _messageCubit.getMyChat(token, loadMore: true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isViewActive && mounted) {
      _startPollingWithToken();
    } else if (state == AppLifecycleState.paused && mounted) {
      _messageCubit.stopPolling();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageCubit.stopPolling();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MessageCubit, MessageState>(
      listener: (context, state) {
        if (state is MessageSuccess && mounted) {
          _isViewActive = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: _messageCubit,
                child: PersonalChatView(
                  reciverImg: state.reciverImg,
                  messageList: state.messages!.data,
                  receiverId: state.userId!,
                  receiverName: state.receiverName,
                  onMessagesUpdated: () async {
                    if (!mounted) return;
                    final token = await _tokenRefreshCubit.getAccessToken();
                    if (token != null) {
                      await _messageCubit.getMyChat(token);
                    }
                  },
                ),
              ),
            ),
          ).then((_) async {
            if (!mounted) return;
            _isViewActive = true;
            _messageCubit.stopPolling();
            await Future.delayed(const Duration(milliseconds: 100));
            final token = await _tokenRefreshCubit.getAccessToken();
            if (token != null && mounted) {
              await _messageCubit.getMyChat(token);
              _startPollingWithToken();
            }
          });
        } else if (state is MessageFailure && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Messages Error: ${state.errorMessage}",
              SnackBarType.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return StreamBuilder<ListChatModel?>(
          stream: _messageCubit.chatStream,
          initialData: _messageCubit.initialChats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.hasData && snapshot.data != null) {
              final chats = snapshot.data!;
              if (chats.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No chats available"),
                      ElevatedButton(
                        onPressed: () async {
                          if (!mounted) return;
                          final token =
                              await _tokenRefreshCubit.getAccessToken();
                          if (token != null) {
                            await _messageCubit.getMyChat(token);
                          }
                        },
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  if (!mounted) return;
                  final token = await _tokenRefreshCubit.getAccessToken();
                  if (token != null) {
                    await _messageCubit.getMyChat(token);
                  }
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 10),
                  itemCount:
                      chats.data.length + (state is ChatsLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chats.data.length && state is ChatsLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.blue),
                        ),
                      );
                    }
                    final chatData = chats.data[index];
                    DateTime messageTime =
                        DateTime.parse('${chatData.lastMessage.sentAt}Z')
                            .toLocal();
                    String period = messageTime.hour >= 12 ? 'PM' : 'AM';
                    int hour12 =
                        messageTime.hour % 12 == 0 ? 12 : messageTime.hour % 12;
                    String hoursAndMinutes =
                        "$hour12:${messageTime.minute.toString().padLeft(2, '0')} $period";
                    final messageContent = chatData.lastMessage.content ??
                        chatData.lastMessage.filePath ??
                        "No message";
                    if (messageContent == "No message" &&
                        chatData.unseenMessageIds.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ChatPerson(
                      onTap: () async {
                        if (!mounted) return;
                        final personalChatCubit =
                            context.read<PersonalChatCubit>();
                        final token = await _tokenRefreshCubit.getAccessToken();
                        if (token != null && mounted) {
                          await _messageCubit.getMyChat(token);
                          _messageCubit.stopPolling();
                          _isViewActive = false;
                          await _messageCubit.getMessages(
                            receiverImg: chatData.user.imagePath,
                            userId: chatData.user.id.toString(),
                            dateTime: DateTime.now().toUtc().toIso8601String(),
                            pageSize: "20",
                            dateFilter: "0",
                            accessToken: token,
                            receiverName: chatData.user.name,
                          );
                          await personalChatCubit.markAsSeen(
                            token,
                            chatData.unseenMessageIds,
                          );
                        }
                      },
                      name: chatData.user.name,
                      msg: messageContent,
                      isMsg: chatData.lastMessage.content != null,
                      time: hoursAndMinutes,
                      numberMsg: chatData.unseenMessageIds.length,
                      image: chatData.user.imagePath,
                    );
                  },
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No chats available"),
                  ElevatedButton(
                    onPressed: () async {
                      if (!mounted) return;
                      final token = await _tokenRefreshCubit.getAccessToken();
                      if (token != null) {
                        await _messageCubit.getMyChat(token);
                      }
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
