import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileUploadProgressIndicator extends StatelessWidget {
  final String clientMessageId;
  final String fileName;
  final double progress;
  
  const FileUploadProgressIndicator({
    super.key,
    required this.clientMessageId,
    required this.fileName,
    required this.progress,
  });
  
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonalChatCubit>();
    final String displayName = fileName.length > 15 
        ? '${fileName.substring(0, 12)}...' 
        : fileName;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.blue100_2.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.blue100_1.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_file,
                size: 20,
                color: context.theme.blue100_1,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayName,
                  style: AppStyles.medium15(context).copyWith(
                    color: context.theme.blue100_1,
                  ),
                ),
              ),
              if (progress < 100)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: context.theme.black50,
                  ),
                  onPressed: () {
                    cubit.cancelUpload(clientMessageId);
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: context.theme.blue100_2.withOpacity(0.2),
                  color: context.theme.blue100_1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${progress.toInt()}%',
                style: AppStyles.regular12(context).copyWith(
                  color: context.theme.black50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}