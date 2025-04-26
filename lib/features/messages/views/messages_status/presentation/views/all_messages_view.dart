import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/chat_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/app_assets.dart';
import '../../../../model/dummy.dart';
import '../../../personal_chat/presentation/views/personal_chat_view.dart';

class AllMessagesView extends StatelessWidget {
  const AllMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          itemCount: 2,
          itemBuilder: (context, index) => ChatPerson(
            onTap: () {
              print("hre");
              context.read<MessageCubit>().getMessages(
                  "11",
                  "2025-06-03T09:49:51.7950956",
                  "30",
                  "0",
                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMCIsImp0aSI6IjgwNzNmZGJlLWVhMjEtNDQzNi1hYzg4LWE0MjE5OGIyMGM4OSIsInVzZXJuYW1lIjoiUmVudGVyIiwidWlkIjoiMjAiLCJyb2xlcyI6WyJVc2VyIiwiUmVudGVyIl0sImV4cCI6MTc0NTY5NzE5NywiaXNzIjoiQWdnYXJBcGkiLCJhdWQiOiJGbHV0dGVyIn0.6X8RMAOnWtrI8UQbPK_NQCk9bbxNJJFXT46uSM27SqQ");
              if (state is MessageSuccess && state.messages != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalChatView(
                      messageList: state.messages!.data,
                    ),
                  ),
                );
              } else if (state is MessageFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            name: names[index],
            msg:
                "Hello! Excited to connect everyone!Hello! Excited to connect with everyone!",
            time: "12:00 am",
            numberMsg: 8,
            image: AppAssets.assetsImagesAvatar,
          ),
        );
      },
    );
  }
}
