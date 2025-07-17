import 'package:aggar/core/cubit/user_review_cubit/user_review_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/vehicles_details/presentation/widgets/custom_icon_button.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/owner_image_section.dart';
import 'package:aggar/features/vehicles_details/presentation/views/about_tab_bar/widgets/owner_name_section.dart';
import 'package:aggar/features/messages/views/personal_chat/presentation/views/personal_chat_view.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_cubit.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/cubit/message_cubit/message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubit/refresh token/token_refresh_cubit.dart';
import '../../../../../../core/cubit/user_cubit/user_info_cubit.dart';
import '../../../../../profile/presentation/views/show_profile_screen.dart';
import '../../../../../vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';

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
              color: context.theme.black100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final tokenCubit = context.read<TokenRefreshCubit>();
                    final token = await tokenCubit.ensureValidToken();
                    if (token != null) {
                      context
                          .read<UserInfoCubit>()
                          .fetchUserInfo(renterId.toString(), token);
                      context
                          .read<UserReviewCubit>()
                          .getUserReviews(renterId.toString(), token);
                      context
                          .read<ReviewCountCubit>()
                          .getUserReviewsNumber(renterId.toString(), token);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowProfileScreen(
                            user: UserModel(
                                id: renterId,
                                name: renterName,
                                username: "",
                                imagePath: pfpImage),
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      OwnerImageSection(
                        pfpImage: pfpImage,
                      ),
                      OwnerNameSection(
                        renterName: renterName,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                BlocListener<MessageCubit, MessageState>(
                  listener: (context, state) {
                    if (state is MessageSuccess) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalChatView(
                            messageList: state.messages!.data,
                            receiverId: renterId,
                            receiverName: renterName,
                            reciverImg: pfpImage,
                            onMessagesUpdated: () {},
                          ),
                        ),
                      );
                    }
                  },
                  child: GestureDetector(
                    onTap: () async {
                      final tokenCubit = context.read<TokenRefreshCubit>();
                      final token = await tokenCubit.getAccessToken();
                      if (token != null) {
                        final messageCubit = context.read<MessageCubit>();
                        await messageCubit.getMessages(
                          userId: renterId.toString(),
                          dateTime: DateTime.now().toUtc().toIso8601String(),
                          pageSize: "20",
                          dateFilter: "0",
                          accessToken: token,
                          receiverName: renterName,
                          receiverImg: pfpImage,
                        );
                      }
                    },
                    child: const CustomIconButton(
                      imageIcon: AppAssets.assetsIconsChat,
                      flag: false,
                    ),
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
