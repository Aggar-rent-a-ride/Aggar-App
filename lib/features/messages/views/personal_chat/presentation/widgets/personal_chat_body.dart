import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_reciver.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_sender.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/send_messages_with_attach_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalChatBody extends StatefulWidget {
  const PersonalChatBody({
    super.key,
    required this.currentUserId,
  });
  final int currentUserId;

  @override
  State<PersonalChatBody> createState() => _PersonalChatBodyState();
}

class _PersonalChatBodyState extends State<PersonalChatBody> {
  @override
  void initState() {
    super.initState();
    final realTimeCubit = context.read<RealTimeChatCubit>();
    realTimeCubit.stream.listen((state) {
      if (state is FileUploadComplete) {
        final personalChatCubit = context.read<PersonalChatCubit>();
        personalChatCubit.setMessages(realTimeCubit.messages);
        _scrollToBottom();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    final cubit = context.read<PersonalChatCubit>();
    if (cubit.scrollController.hasClients) {
      cubit.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _shouldDisplayMessage(MessageModel message, PersonalChatCubit cubit) {
    if (message.filePath != null &&
        message.filePath!.startsWith('uploading://')) {
      return false;
    }
    return !message.isOptimistic || message.content != null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RealTimeChatCubit, RealTimeChatState>(
      listenWhen: (previous, current) =>
          current is FileUploadComplete ||
          current is MessageSentSuccessfully ||
          current is MessageAddedState,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
      buildWhen: (previous, current) =>
          current is PersonalChatInitial ||
          current is FileUploadInProgress ||
          current is FileUploadComplete ||
          current is FileUploadFailed ||
          current is MessageAddedState ||
          current is MessageUpdatedState,
      builder: (context, state) {
        final cubit = context.read<PersonalChatCubit>();
        final List<MessageModel> messages = cubit.messages;
        final filteredMessages = messages
            .where((message) => _shouldDisplayMessage(message, cubit))
            .toList();

        Map<String, List<MessageModel>> groupedMessages = {};
        for (var message in filteredMessages) {
          DateTime dateTime = DateTime.parse(message.sentAt);
          String dateOnly =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

          if (!groupedMessages.containsKey(dateOnly)) {
            groupedMessages[dateOnly] = [];
          }
          groupedMessages[dateOnly]!.add(message);
        }

        List<String> sortedDates = groupedMessages.keys.toList()
          ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: cubit.scrollController,
                  reverse: true, // Display newest messages at the bottom
                  cacheExtent: 2000.0,
                  itemCount: sortedDates.length,
                  itemBuilder: (context, groupIndex) {
                    String date = sortedDates[groupIndex];
                    List<MessageModel> messagesForDate = groupedMessages[date]!;
                    messagesForDate.sort((a, b) => DateTime.parse(a.sentAt)
                        .compareTo(DateTime.parse(b.sentAt)));
                    DateTime dateTime = DateTime.parse(date);
                    String formattedDate = getFormattedDate(dateTime);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.theme.blue100_2.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                formattedDate,
                                style: AppStyles.medium14(context).copyWith(
                                  color: context.theme.blue100_1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ...messagesForDate.map((message) {
                          final messageId = message.id.toString();
                          final dateTime = DateTime.parse(message.sentAt);
                          final hoursAndMinutes =
                              "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
                          final isHighlighted =
                              cubit.highlightedMessageId == messageId;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            key: cubit.messageKeys[messageId],
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? context.theme.blue100_2.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: message.senderId == widget.currentUserId
                                ? ChatBubbleForSender(
                                    isfile: message.filePath != null,
                                    message: Message(
                                      message.content == null
                                          ? message.filePath!
                                          : message.content!,
                                      messageId,
                                      hoursAndMinutes,
                                    ),
                                  )
                                : ChatBubbleForReciver(
                                    isfile: message.filePath != null,
                                    message: Message(
                                      message.content == null
                                          ? message.filePath!
                                          : message.content!,
                                      messageId,
                                      hoursAndMinutes,
                                    ),
                                  ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
              const SendMessagesWithAttachSection(),
            ],
          ),
        );
      },
    );
  }
}
