import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_mini_type_file.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:flutter/material.dart';

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
    final type = await getFileMimeType(widget.message.message);
    if (mounted) {
      setState(() {
        mimeType = type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.65;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: context.theme.white100_2,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 0),
            )
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.isfile == false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  widget.message.message,
                  style: AppStyles.medium18(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: mimeType == "image"
                    ? Image.network(
                        "${EndPoint.baseUrl}${widget.message.message}",
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.file_present_outlined,
                        size: 50,
                      ),
              ),
            Text(
              widget.message.time,
              style: AppStyles.medium12(context).copyWith(
                color: context.theme.black25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
