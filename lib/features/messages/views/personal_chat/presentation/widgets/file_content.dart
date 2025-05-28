import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/helper/file_handler.dart';
import 'package:aggar/core/helper/formate_size.dart';
import 'package:aggar/core/helper/get_file_extention.dart';
import 'package:aggar/core/helper/get_file_name.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/model/message.dart';
import 'package:flutter/material.dart';

class FileContent extends StatelessWidget {
  const FileContent({
    super.key,
    required this.message,
    required this.fileName,
    required this.fileSizeInBytes,
    required this.mimeType,
    required this.isSender,
  });

  final Message message;
  final String fileName;
  final int? fileSizeInBytes;
  final String? mimeType;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final fileName = getFileName(message.message);
        final file = await FileHandler.downloadFile(
          "${EndPoint.baseUrl}${message.message}",
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
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.file_copy_rounded,
            size: 25,
            color:
                isSender ? context.theme.white100_1 : context.theme.blue100_1,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppStyles.medium16(context).copyWith(
                    color: isSender
                        ? context.theme.white100_1
                        : context.theme.blue100_1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      formatFileSize(fileSizeInBytes),
                      style: AppStyles.medium12(context).copyWith(
                        color: (isSender
                                ? context.theme.white100_1
                                : context.theme.blue100_1)
                            .withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      getFileExtension(fileName),
                      style: AppStyles.medium12(context).copyWith(
                        color: (isSender
                                ? context.theme.white100_1
                                : context.theme.blue100_1)
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
