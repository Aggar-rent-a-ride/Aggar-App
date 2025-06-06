import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/helper/file_handler.dart';
import 'package:aggar/core/helper/get_file_name.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/person_image_with_name.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/image_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class MessageTargetTypeCard extends StatelessWidget {
  final String? content;
  final String? filePath;
  final int id;
  final int senderId;
  final int receiverId;
  final DateTime sentAt;
  final String? senderName;
  final String? senderImagePath;
  final String? receiverImagePath;
  final String? receiverName;

  const MessageTargetTypeCard({
    super.key,
    this.content,
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    this.senderName,
    this.senderImagePath,
    this.filePath,
    this.receiverName,
    this.receiverImagePath,
  });

  IconData getFileIcon(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy, h:mm a');
    final formattedDate = dateFormat.format(sentAt);
    final isFile = filePath != null;

    return Container(
      decoration: BoxDecoration(
        color: context.theme.blue10_2,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              isFile ? "File content" : "Message content",
              style: AppStyles.medium15(context).copyWith(
                color: context.theme.black50,
              ),
            ),
            const Gap(8),
            if (content != null)
              Text(
                content!,
                style: AppStyles.bold20(context).copyWith(
                  color: context.theme.black100,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            else if (isFile)
              GestureDetector(
                onTap: () async {
                  final fileName = getFileName(filePath!);
                  final extension = filePath!.split('.').last.toLowerCase();
                  if (['jpg', 'jpeg', 'png'].contains(extension)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageView(
                          imageUrl: "${EndPoint.baseUrl}$filePath",
                          imagefrom: fileName,
                        ),
                      ),
                    );
                  } else {
                    final file = await FileHandler.downloadFile(
                      "${EndPoint.baseUrl}$filePath",
                      fileName,
                    );
                    if (file != null) {
                      await FileHandler.openFile(file);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackBar(
                          context,
                          "Error",
                          "Failed to download file",
                          SnackBarType.error,
                        ),
                      );
                    }
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      getFileIcon(filePath!),
                      color: context.theme.blue100_1,
                      size: 26,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        getFileName(filePath!),
                        style: AppStyles.bold20(context).copyWith(
                          color: context.theme.black100,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PersonImageWithName(
                  imagePath: senderImagePath,
                  name: senderName,
                  id: senderId,
                ),
                PersonImageWithName(
                  imagePath: receiverImagePath,
                  name: receiverName,
                  id: receiverId,
                ),
              ],
            ),
            const Gap(8),
            Text(
              formattedDate,
              style: AppStyles.regular12(context).copyWith(
                color: context.theme.black50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
