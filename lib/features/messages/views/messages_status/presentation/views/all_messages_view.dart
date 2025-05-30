import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/list_chat_model.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/chat_person.dart';
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
  bool _isViewActive = true; // Track if AllMessagesView is the active view

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _messageCubit = context.read<MessageCubit>();
    WidgetsBinding.instance.addObserver(this);
    _startPollingWithToken();
  }

  Future<void> _startPollingWithToken() async {
    if (!_isViewActive) return; // Only start polling if view is active
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.getAccessToken();
    if (token != null) {
      _messageCubit.startPolling(token, isViewActive: true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _isViewActive) {
      // Only resume polling if AllMessagesView is active
      _startPollingWithToken();
    } else if (state == AppLifecycleState.paused) {
      _messageCubit.stopPolling();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageCubit.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<MessageCubit, MessageState>(
      listener: (context, state) {
        if (state is MessageSuccess) {
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
                ),
              ),
            ),
          ).then((_) {
            _isViewActive = true;
            _startPollingWithToken();
          });
        } else if (state is MessageFailure) {
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
            if (snapshot.data == null && state is ChatsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.hasData && snapshot.data != null) {
              final chats = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async {
                  final tokenCubit = context.read<TokenRefreshCubit>();
                  final token = await tokenCubit.getAccessToken();
                  if (token != null) await _messageCubit.getMyChat(token);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: chats.data.length,
                  itemBuilder: (context, index) {
                    final chatData = chats.data[index];
                    DateTime messageTime =
                        DateTime.parse('${chatData.lastMessage.sentAt}Z')
                            .toLocal();
                    String period = messageTime.hour >= 12 ? 'PM' : 'AM';
                    int hour12 =
                        messageTime.hour % 12 == 0 ? 12 : messageTime.hour % 12;
                    String hoursAndMinutes =
                        "$hour12:${messageTime.minute.toString().padLeft(2, '0')} $period";
                    return ChatPerson(
                      onTap: () async {
                        final tokenCubit = context.read<TokenRefreshCubit>();
                        final token = await tokenCubit.getAccessToken();
                        if (token != null) {
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
                        }
                      },
                      name: chatData.user.name,
                      msg: chatData.lastMessage.content ??
                          chatData.lastMessage.filePath ??
                          "No message",
                      isMsg:
                          chatData.lastMessage.content != null ? true : false,
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
                      final tokenCubit = context.read<TokenRefreshCubit>();
                      final token = await tokenCubit.getAccessToken();
                      if (token != null) _messageCubit.getMyChat(token);
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
