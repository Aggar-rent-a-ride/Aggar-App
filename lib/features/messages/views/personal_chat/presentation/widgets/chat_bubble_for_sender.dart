import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/utils/app_styles.dart';

class ChatBubbleForSender extends StatefulWidget {
  const ChatBubbleForSender({super.key, required this.message, this.isfile});
  final Message message;
  final bool? isfile;

  @override
  State<ChatBubbleForSender> createState() => _ChatBubbleForSenderState();
}

class _ChatBubbleForSenderState extends State<ChatBubbleForSender> {
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
        left: MediaQuery.of(context).size.width * 0.2,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: context.theme.blue100_1,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
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
                        color: context.theme.white100_1,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      widget.message.time,
                      style: AppStyles.medium12(context).copyWith(
                        color: context.theme.white100_2,
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
                        color: context.theme.white100_2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
