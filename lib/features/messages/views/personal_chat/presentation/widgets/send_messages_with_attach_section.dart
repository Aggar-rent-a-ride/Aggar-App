import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat/personal_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_cubit.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/real%20time%20chat/real_time_chat_state.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/file_upload_progress_indicator.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/widgets/type_message_text_field_with_send_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessagesWithAttachSection extends StatelessWidget {
  const SendMessagesWithAttachSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RealTimeChatCubit, RealTimeChatState>(
      buildWhen: (previous, current) =>
          current is FileUploadInProgress ||
          current is FileUploadComplete ||
          current is FileUploadFailed ||
          current is PersonalChatInitial,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state is FileUploadInProgress)
              FileUploadProgressIndicator(
                clientMessageId: state.clientMessageId,
                fileName: state.fileName,
              ),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.09,
              width: double.infinity,
              color: context.theme.white100_1,
              child: const TypeMessageTextFieldWithSendButton(),
            ),
          ],
        );
      },
    );
  }
}