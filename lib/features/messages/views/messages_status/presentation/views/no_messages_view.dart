import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubit/refresh token/token_refresh_cubit.dart';

class NoMessagesView extends StatelessWidget {
  const NoMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage(
            AppAssets.assetsImagesNochat,
          ),
          height: 225,
          width: 225,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "no chats yet!",
              style: AppStyles.medium20(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
            TextButton(
              onPressed: () async {
                final tokenCubit = context.read<TokenRefreshCubit>();
                final token = await tokenCubit.ensureValidToken();
                final messageCubit = context.read<MessageCubit>();
                if (token != null) {
                  await messageCubit.getMyChat(token);
                }
              },
              child: Text(
                "Refresh",
                style: AppStyles.medium20(context).copyWith(
                  color: context.theme.blue100_2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
