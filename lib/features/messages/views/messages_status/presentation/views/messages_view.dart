import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/views/all_messages_view.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/app_styles.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        backgroundColor: context.theme.white100_1,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: AppStyles.semiBold24(
            context,
          ).copyWith(color: context.theme.black100),
        ),
      ),
      backgroundColor: context.theme.white100_1,
      body: const AllMessagesView(),
    );
  }
}
