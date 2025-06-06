import 'package:aggar/core/cubit/reportId/report_by_id_state.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/message_target_type_card.dart';
import 'package:flutter/material.dart';

class MessageTargetType extends StatelessWidget {
  const MessageTargetType({super.key, required this.state});
  final ReportByIdLoaded state;
  @override
  Widget build(BuildContext context) {
    return MessageTargetTypeCard(
      content: state.report.targetMessage?.content,
      filePath: state.report.targetFile?.filePath,
      id: state.report.targetMessage != null
          ? state.report.targetMessage!.id
          : state.report.targetFile!.id,
      senderId: state.report.targetMessage != null
          ? state.report.targetMessage!.senderId
          : state.report.targetFile!.senderId,
      receiverId: state.report.targetMessage != null
          ? state.report.targetMessage!.receiverId
          : state.report.targetFile!.receiverId,
      sentAt: DateTime.parse(
        state.report.targetMessage != null
            ? state.report.targetMessage!.sentAt
            : state.report.targetFile!.sentAt,
      ),
    );
  }
}
