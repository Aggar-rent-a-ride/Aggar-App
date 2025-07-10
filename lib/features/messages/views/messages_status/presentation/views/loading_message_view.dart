import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/loading_chat_person.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingMessageView extends StatelessWidget {
  const LoadingMessageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.grey100_1,
      highlightColor: context.theme.white100_1,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
              spacing: 35,
              children: List.generate(
                15,
                (index) => const LoadingChatPerson(),
              )),
        ),
      ),
    );
  }
}
