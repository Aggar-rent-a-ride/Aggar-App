import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/personal_chat/data/cubit/personal_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MessageTextFieldWithAttachmentButton extends StatelessWidget {
  const MessageTextFieldWithAttachmentButton({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonalChatCubit>();
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: TextField(
          controller: cubit.messageController,
          cursorColor: context.theme.blue100_2,
          cursorOpacityAnimates: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: context.theme.white100_2,
            hintText: 'Message',
            hintStyle: AppStyles.medium18(context).copyWith(
              color: context.theme.black50,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Transform.rotate(
                angle: 45 * (3.1415927 / 180),
                child: IconButton(
                  onPressed: () async {
                    // await _pickAndSendFile(context);
                  },
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: context.theme.black50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Future<void> _pickAndSendFile(BuildContext context) async {
  //   final cubit = context.read<PersonalChatCubit>();
    
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.any,
  //       allowMultiple: false,
  //     );
      
  //     if (result == null || result.files.isEmpty) {
  //       return;
  //     }
      
  //     final file = File(result.files.first.path!);
  //     final fileName = result.files.first.name;
  //     final fileExtension = fileName.split('.').last;
  //     final bytes = await file.readAsBytes();
      
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Sending file...'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     final int receiverId = 11;
      
  //     await cubit.sendFile(
  //       receiverId,
  //       file.path,
  //       bytes,
  //       fileName,
  //       fileExtension,
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to send file: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }
}