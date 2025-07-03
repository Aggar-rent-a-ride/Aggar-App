import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_file_name.dart';
import 'package:aggar/core/helper/get_mini_type_file.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/image_view.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/file_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBubbleForReciver extends StatefulWidget {
  const ChatBubbleForReciver(
      {super.key,
      required this.message,
      this.isfile = false,
      required this.reciverName});
  final Message message;
  final bool? isfile;
  final String reciverName;

  @override
  State<ChatBubbleForReciver> createState() => _ChatBubbleForReciverState();
}

class _ChatBubbleForReciverState extends State<ChatBubbleForReciver> {
  String? mimeType;
  int? fileSizeInBytes;

  @override
  void initState() {
    super.initState();
    if (widget.isfile == true) {
      loadMimeTypeAndSize();
    }
  }

  void loadMimeTypeAndSize() async {
    final type = await getFileMimeType(widget.message.message);
    final url = "${EndPoint.baseUrl}${widget.message.message}";
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        final contentLength = response.headers['content-length'];
        if (contentLength != null) {
          fileSizeInBytes = int.tryParse(contentLength);
        }
      }
    } catch (e) {
      print('Error fetching file size: $e');
    }
    if (mounted) {
      setState(() {
        mimeType = type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.65;
    final fileName =
        widget.isfile == true ? getFileName(widget.message.message) : '';
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: context.theme.white100_4,
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
                  style: AppStyles.medium16(context)
                      .copyWith(color: context.theme.black100),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: mimeType == "image"
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                imageUrl:
                                    "${EndPoint.baseUrl}${widget.message.message}",
                                imagefrom: widget.reciverName,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          "${EndPoint.baseUrl}${widget.message.message}",
                          width: 240,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      )
                    : FileContent(
                        message: widget.message,
                        isSender: false,
                        fileName: fileName,
                        fileSizeInBytes: fileSizeInBytes,
                        mimeType: mimeType,
                      ),
              ),
            Text(
              widget.message.time,
              style: AppStyles.medium12(context).copyWith(
                color: context.theme.black50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
