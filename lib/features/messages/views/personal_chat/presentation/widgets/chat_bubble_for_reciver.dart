import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ChatBubbleForReciver extends StatefulWidget {
  const ChatBubbleForReciver(
      {super.key, required this.message, this.isfile = false});
  final Message message;
  final bool? isfile;

  @override
  State<ChatBubbleForReciver> createState() => _ChatBubbleForReciverState();
}

class _ChatBubbleForReciverState extends State<ChatBubbleForReciver> {
  String? mimeType;

  @override
  void initState() {
    super.initState();
    if (widget.isfile == true) {
      loadMimeType();
    }
  }

  void loadMimeType() async {
    final type = await context
        .read<MessageCubit>()
        .getFileMimeType(widget.message.message);
    if (mounted) {
      setState(() {
        mimeType = type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.15,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: context.theme.white100_2,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: widget.isfile == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.message.message,
                      style: AppStyles.medium16(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      widget.message.time,
                      style: AppStyles.medium12(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: mimeType == "image"
                          ? Image.network(
                              "${EndPoint.baseUrl}${widget.message.message}",
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.file_present_outlined,
                              size: 50,
                            ),
                    ),
                    const Gap(5),
                    Text(
                      widget.message.time,
                      style: AppStyles.medium12(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
