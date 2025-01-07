import 'package:aggar/core/utils/app_colors.dart';
import 'package:aggar/features/messages/presentation/views/no_message_view.dart';
import 'package:aggar/features/messages/presentation/views/request_message_view.dart';
import 'package:aggar/features/messages/presentation/widgets/message_app_bar_with_tab_bar.dart';
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

final List<String> names = [
  'Brian Smith',
  'Claire Davis',
  'Alice Johnson',
  'David Wilson',
  'Frank Garcia',
  'Grace Martinez',
  'Henry Lopez',
  'Isabella Taylor',
  'Alice Johnson',
  'David Wilson',
  'Frank Garcia',
  'Grace Martinez',
  'Henry Lopez',
  'Isabella Taylor',
];
