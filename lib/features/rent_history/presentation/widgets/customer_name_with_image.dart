import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/personal_chat_view.dart';
import 'package:aggar/features/rent_history/data/models/rental_history_models.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CustomerNameWithImage extends StatelessWidget {
  const CustomerNameWithImage({
    super.key,
    required this.rentalItem,
  });

  final RentalHistoryItem rentalItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer information",
          style: AppStyles.semiBold15(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        Row(
          children: [
            AvatarChatView(
              image: rentalItem.user.imagePath,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rentalItem.user.name,
                    style: AppStyles.medium16(context).copyWith(
                      color: context.theme.black100,
                    ),
                  ),
                  Text(
                    "Customer",
                    style: AppStyles.medium12(context).copyWith(
                      color: context.theme.black50,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PersonalChatView(
                      messageList: const [],
                      receiverId: rentalItem.user.id,
                      receiverName: rentalItem.user.name,
                      reciverImg: rentalItem.user.imagePath,
                      onMessagesUpdated: () {},
                    ),
                  ),
                );
              },
              child: const CustomIconButton(
                imageIcon: AppAssets.assetsIconsChat,
                flag: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
