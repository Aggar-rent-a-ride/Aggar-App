import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_state.dart';

class FileUploadProgressIndicator extends StatelessWidget {
  final String clientMessageId;
  final String fileName;

  const FileUploadProgressIndicator({
    super.key,
    required this.clientMessageId,
    required this.fileName,
  });
  String _truncateFileName(String name) {
    return name.length > 20 ? '${name.substring(0, 17)}...' : name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalChatCubit, PersonalChatState>(
      buildWhen: (previous, current) => 
        current is FileUploadInProgress && 
        current.clientMessageId == clientMessageId,
      builder: (context, state) {
        if (state is! FileUploadInProgress) {
          return const SizedBox.shrink();
        }

        final cubit = context.read<PersonalChatCubit>();
        final progress = state.progress;

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
                      _truncateFileName(fileName),
                      style: AppStyles.medium15(context).copyWith(
                        color: context.theme.blue100_1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 12,
                        child: LiquidLinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: context.theme.blue100_2.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.theme.blue100_1,
                          ),
                          borderRadius: 10,
                          direction: Axis.horizontal,
                        ),
                      ),
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
      },
    );
  }
}