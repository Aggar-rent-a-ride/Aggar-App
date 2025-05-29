import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_formatted_date.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/messages_status/data/model/message_model.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_cubit.dart';
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
    required this.reciverName,
  });
  final int currentUserId;
  final String reciverName;

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
    final realTimeCubit = context.read<RealTimeChatCubit>();
    if (realTimeCubit.scrollController.hasClients) {
      realTimeCubit.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _shouldDisplayMessage(MessageModel message) {
    if (message.filePath != null &&
        message.filePath!.startsWith('uploading://')) {
      return false;
    }
    return message.content != null ||
        (message.filePath != null &&
            !message.filePath!.startsWith('uploading://'));
  }

  List<MessageModel> _getFilteredMessages(List<MessageModel> messages) {
    return messages.where((message) => _shouldDisplayMessage(message)).toList();
  }

  Map<String, List<MessageModel>> _groupMessagesByDate(
      List<MessageModel> messages) {
    Map<String, List<MessageModel>> groupedMessages = {};
    for (var message in messages) {
      DateTime dateTime;
      try {
        // Ensure sentAt is treated as UTC by appending 'Z' if needed
        String sentAt = message.sentAt.endsWith('Z')
            ? message.sentAt
            : '${message.sentAt}Z';
        dateTime = DateTime.parse(sentAt).toLocal();
      } catch (e) {
        dateTime = DateTime.now();
      }
      String dateOnly =
          "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
      if (!groupedMessages.containsKey(dateOnly)) {
        groupedMessages[dateOnly] = [];
      }
      groupedMessages[dateOnly]!.add(message);
    }
    return groupedMessages;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RealTimeChatCubit, RealTimeChatState>(
      listener: (context, realTimeState) {
        print("🎯 RealTime state changed: ${realTimeState.runtimeType}");
        if (realTimeState is MessageAddedState ||
            realTimeState is MessageUpdatedState ||
            realTimeState is FileUploadComplete ||
            realTimeState is MessageSentSuccessfully) {
          print(
              "📱 UI update triggered by state: ${realTimeState.runtimeType}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
        if (realTimeState is ConnectionStatusChanged) {
          print("🔗 Connection status changed: ${realTimeState.isConnected}");
        }
      },
      child: BlocBuilder<RealTimeChatCubit, RealTimeChatState>(
        buildWhen: (previous, current) {
          print(
              "🏗️ BlocBuilder buildWhen: ${previous.runtimeType} -> ${current.runtimeType}");
          return true;
        },
        builder: (context, realTimeState) {
          print("🏗️ Building UI with state: ${realTimeState.runtimeType}");
          final realTimeCubit = context.read<RealTimeChatCubit>();
          final personalCubit = context.read<PersonalChatCubit>();
          final List<MessageModel> messages = realTimeCubit.messages;
          print("📊 Current messages count: ${messages.length}");
          final filteredMessages = _getFilteredMessages(messages);
          final groupedMessages = _groupMessagesByDate(filteredMessages);
          List<String> sortedDates = groupedMessages.keys.toList()
            ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

          return Expanded(
            child: Column(
              children: [
                if (realTimeState is ConnectionStatusChanged &&
                    !realTimeState.isConnected)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.withOpacity(0.1),
                    child: Text(
                      "Disconnected from chat server",
                      textAlign: TextAlign.center,
                      style: AppStyles.medium12(context).copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                if (realTimeState is RealTimeChatLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: context.theme.blue100_2.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.theme.blue100_1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Connecting...",
                          style: AppStyles.medium12(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (realTimeState is MessageAddedState)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    color: Colors.green.withOpacity(0.1),
                    child: Text(
                      "New message received",
                      textAlign: TextAlign.center,
                      style: AppStyles.medium10(context).copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: realTimeCubit.scrollController,
                    reverse: true,
                    cacheExtent: 2000.0,
                    itemCount: sortedDates.length,
                    itemBuilder: (context, groupIndex) {
                      String date = sortedDates[groupIndex];
                      List<MessageModel> messagesForDate =
                          groupedMessages[date]!;
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
                                  color:
                                      context.theme.blue100_2.withOpacity(0.1),
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
                            String sentAt = message.sentAt.endsWith('Z')
                                ? message.sentAt
                                : '${message.sentAt}Z';
                            final dateTime = DateTime.parse(sentAt).toLocal();
                            String period = dateTime.hour >= 12 ? 'PM' : 'AM';
                            int hour12 = dateTime.hour % 12 == 0
                                ? 12
                                : dateTime.hour % 12;
                            final hoursAndMinutes =
                                "$hour12:${dateTime.minute.toString().padLeft(2, '0')} $period";

                            final isHighlighted =
                                personalCubit.highlightedMessageId == messageId;

                            if (!personalCubit.messageKeys
                                .containsKey(messageId)) {
                              personalCubit.messageKeys[messageId] =
                                  GlobalKey();
                            }

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              key: personalCubit.messageKeys[messageId],
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: isHighlighted
                                    ? context.theme.blue100_2.withOpacity(0.1)
                                    : Colors.transparent,
                                border: (realTimeState is MessageAddedState &&
                                        realTimeState.message.id == message.id)
                                    ? Border.all(
                                        color: Colors.green.withOpacity(0.5),
                                        width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
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
                                      reciverName: widget.reciverName,
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
      ),
    );
  }
}
