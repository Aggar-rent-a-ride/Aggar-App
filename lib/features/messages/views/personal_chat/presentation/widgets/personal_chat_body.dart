import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_reciver.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/chat_bubble_for_sender.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/send_messages_with_attach_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalChatBody extends StatefulWidget {
  const PersonalChatBody({
    super.key,
    required this.messageList,
    required this.currentUserId,
  });
  final List<MessageModel> messageList;
  final int currentUserId;

  @override
  State<PersonalChatBody> createState() => _PersonalChatBodyState();
}

class _PersonalChatBodyState extends State<PersonalChatBody> {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonalChatCubit>();
    Map<String, List<MessageModel>> groupedMessages = {};
    for (var message in widget.messageList) {
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
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: context.theme.blue100_2.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          formattedDate,
                          style: AppStyles.regular15(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                      ),
                    ),
                    ...messagesForDate.map(
                      (message) {
                        DateTime messageTime = DateTime.parse(message.sentAt);
                        String period = messageTime.hour >= 12 ? 'PM' : 'AM';
                        int hour12 = messageTime.hour % 12;
                        if (hour12 == 0) hour12 = 12;
                        String hoursAndMinutes =
                            "${hour12.toString()}:${messageTime.minute.toString().padLeft(2, '0')} $period";
                        String messageId = message.id.toString();
                        if (!cubit.messageKeys.containsKey(messageId)) {
                          cubit.messageKeys[messageId] = GlobalKey();
                        }
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
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          const SendMessagesWithAttachSection(),
        ],
      ),
    );
  }
}
