import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/image_and_name_person_message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/menu_icon_button.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/personal_chat_body.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/search_for_msg_by_content_or_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalChatView extends StatefulWidget {
  const PersonalChatView({
    super.key,
    required this.messageList,
    this.onMessagesUpdated,
    required this.receiverId,
    required this.receiverName,
  });

  final List<MessageModel> messageList;
  final int receiverId;
  final VoidCallback? onMessagesUpdated;
  final String receiverName;
  @override
  State<PersonalChatView> createState() => _PersonalChatViewState();
}

class _PersonalChatViewState extends State<PersonalChatView> {
  late final PersonalChatCubit personalChatCubit;
  late final RealTimeChatCubit realTimeChatCubit;
  int senderId = 0;

  @override
  void initState() {
    super.initState();
    personalChatCubit = PersonalChatCubit();
    realTimeChatCubit = RealTimeChatCubit();

    print('PersonalChatView initialized with receiverId: ${widget.receiverId}');

    personalChatCubit.setMessages(widget.messageList);
    personalChatCubit.setReceiverId(widget.receiverId);

    realTimeChatCubit.setMessages(widget.messageList);
    realTimeChatCubit.setReceiverId(widget.receiverId);

    _initializeUser();

    realTimeChatCubit.stream.listen((state) {
      if (state is MessageAddedState || state is MessageUpdatedState) {
        personalChatCubit.setMessages(realTimeChatCubit.messages);
      }
    });
  }

  Future<void> _initializeUser() async {
    await realTimeChatCubit.initializeSenderId();
    setState(() {
      senderId = realTimeChatCubit.senderId;
    });
  }

  @override
  void dispose() {
    widget.onMessagesUpdated?.call();
    personalChatCubit.close();
    realTimeChatCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: personalChatCubit),
        BlocProvider.value(value: realTimeChatCubit),
      ],
      child: BlocBuilder<PersonalChatCubit, PersonalChatState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: context.theme.white100_2,
              ),
              elevation: 1,
              shadowColor: Colors.grey[900],
              centerTitle: false,
              surfaceTintColor: Colors.transparent,
              backgroundColor: context.theme.blue100_1,
              title: personalChatCubit.isSearchActive
                  ? SearchForMsgByContentOrDate(cubit: personalChatCubit)
                  : ImageAndNamePersonMessage(
                      name: widget.receiverName,
                    ),
              leading: personalChatCubit.isSearchActive
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: context.theme.white100_2,
                      ),
                      onPressed: () {
                        personalChatCubit.clearSearch();
                      },
                    )
                  : null,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: personalChatCubit.isSearchActive
                      ? IconButton(
                          onPressed: () async {
                            personalChatCubit.selectDate(context);
                          },
                          icon: Icon(
                            color: context.theme.white100_2,
                            Icons.date_range_outlined,
                          ),
                        )
                      : MenuIconButton(cubit: personalChatCubit),
                ),
              ],
            ),
            backgroundColor: context.theme.white100_1,
            body: PersonalChatBody(
              currentUserId: senderId,
            ),
          );
        },
      ),
    );
  }
}
