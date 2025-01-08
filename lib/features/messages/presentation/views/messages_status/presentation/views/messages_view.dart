import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/messages/presentation/views/messages_status/presentation/views/no_messages_view.dart';
import 'package:aggar/features/messages/presentation/views/messages_status/presentation/views/request_messages_view.dart';
import 'package:aggar/features/messages/presentation/views/messages_status/presentation/widgets/widgets/message_app_bar_with_tab_bar.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: AppColors.myWhite100_1,
          body: Column(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.myWhite100_1,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.myBlack10,
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const MessageAppBarWithTabBar(),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.84,
                child: const TabBarView(
                  children: [
                    Center(child: NoMessagesView()),
                    Center(child: RequestMessageView()),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
