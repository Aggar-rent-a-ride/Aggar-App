import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_state.dart';
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
  });

  final List<MessageModel> messageList;
  final int receiverId;
  final VoidCallback? onMessagesUpdated;
  @override
  State<PersonalChatView> createState() => _PersonalChatViewState();
}

class _PersonalChatViewState extends State<PersonalChatView> {
  late final PersonalChatCubit cubit;
  int currentUserId = 0;
  String? receiverName;

  @override
  void initState() {
    super.initState();
    cubit = PersonalChatCubit();
    print('PersonalChatView initialized with receiverId: ${widget.receiverId}');
    cubit.setMessages(widget.messageList);
    cubit.setReceiverId(widget.receiverId);
    _initializeUser();
    _fetchReceiverName();
  }

  Future<void> _initializeUser() async {
    await cubit.initializeSenderId();
    setState(() {
      currentUserId = cubit.senderId;
    });
  }

  Future<void> _fetchReceiverName() async {
    setState(() {
      receiverName = "User #${widget.receiverId}";
    });
  }

  @override
  void dispose() {
    widget.onMessagesUpdated?.call();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*<<<<<<< esraa
    int currentUserId = 20; // Replace with the actual current user ID
    return BlocProvider(
      create: (context) => PersonalChatCubit(),
=======*/

    return BlocProvider.value(
      value: cubit,
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
              title: cubit.isSearchActive
                  ? SearchForMsgByContentOrDate(cubit: cubit)
                  : ImageAndNamePersonMessage(
                      name: receiverName ?? "Chat",
                    ),
              leading: cubit.isSearchActive
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: context.theme.white100_2,
                      ),
                      onPressed: () {
                        cubit.clearSearch();
                      },
                    )
                  : null,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: cubit.isSearchActive
                      ? IconButton(
                          onPressed: () {
                            cubit.selectDate(context);
                          },
                          icon: Icon(
                            color: context.theme.white100_2,
                            Icons.date_range_outlined,
                          ),
                        )
                      : MenuIconButton(cubit: cubit),
                ),
              ],
            ),
            backgroundColor: context.theme.white100_1,
            body: PersonalChatBody(
              messageList: cubit.messages,
              currentUserId:
                  cubit.senderId > 0 ? cubit.senderId : currentUserId,
            ),
          );
        },
      ),
    );
  }
}
