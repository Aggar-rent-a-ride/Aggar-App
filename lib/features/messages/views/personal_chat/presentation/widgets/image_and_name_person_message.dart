import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/utils/app_styles.dart';

class ImageAndNamePersonMessage extends StatelessWidget {
  const ImageAndNamePersonMessage({
    super.key,
    required this.name,
    this.image,
  });

  final String name;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarChatView(
          image: image,
          size: 35,
        ),
        const Gap(10),
        Text(
          name,
          style: AppStyles.bold20(context).copyWith(
            color: context.theme.white100_1,
          ),
        ),
      ],
    );
  }
}
