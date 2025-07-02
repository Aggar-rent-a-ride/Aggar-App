import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_icon_button.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/owner_image_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/owner_name_section.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/personal_chat_view.dart';
import 'package:flutter/material.dart';

class RentPartnerSection extends StatelessWidget {
  const RentPartnerSection({
    super.key,
    this.pfpImage,
    required this.renterName,
    required this.renterId,
  });

  final String? pfpImage;
  final String renterName;
  final int renterId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rent Partner",
            style: AppStyles.bold18(context).copyWith(
              color: context.theme.black50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                OwnerImageSection(
                  pfpImage: pfpImage,
                ),
                OwnerNameSection(
                  renterName: renterName,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalChatView(
                          messageList: const [],
                          receiverId: renterId,
                          receiverName: renterName,
                          reciverImg: pfpImage,
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
          )
        ],
      ),
    );
  }
}
