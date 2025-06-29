import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/options_button.dart';
import 'package:aggar/features/messages/views/messages_status/presentation/widgets/widgets/avatar_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../profile/presentation/views/show_profile_screen.dart';
import '../../../../vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';
import '../../../../vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';

class PersonImageWithName extends StatelessWidget {
  const PersonImageWithName({
    super.key,
    required this.id,
    required this.type,
  });

  final int id;
  final String type;

  Future<Map<String, dynamic>> _fetchUserData(BuildContext context) async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.getAccessToken();
    if (token == null) {
      throw Exception('Failed to retrieve access token');
    }
    return await context.read<UserCubit>().getUserById(token, id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: context.theme.gray100_1,
            highlightColor: context.theme.white100_1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                const Gap(5),
                Container(
                  height: 20,
                  width: 90,
                  decoration: BoxDecoration(
                    color: context.theme.white100_1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!['StatusCode'] != 200) {
          return GestureDetector(
            onTap: () async {
              final tokenCubit = context.read<TokenRefreshCubit>();
              final token = await tokenCubit.getAccessToken();
              if (token != null) {
                context
                    .read<UserInfoCubit>()
                    .fetchUserInfo(id.toString(), token);
                context
                    .read<ReviewCubit>()
                    .getUserReviews(id.toString(), token);
                context
                    .read<ReviewCountCubit>()
                    .getUserReviewsNumber(id.toString(), token);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowProfileScreen(
                      user: UserModel(
                        id: id,
                        name: snapshot.data!["data"]["name"],
                        username: "",
                        imagePath: snapshot.data!["data"]["imagePath"],
                      ),
                    ),
                  ),
                );
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AvatarChatView(
                  image: snapshot.data!["data"]["imagePath"],
                  size: 40,
                ),
                const Gap(5),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        snapshot.data!["data"]["name"],
                        style: AppStyles.semiBold16(context).copyWith(
                          color: context.theme.black100,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        type,
                        style: AppStyles.medium12(context).copyWith(
                          color: context.theme.black50,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                OptionsButton(
                    user: UserModel(
                        id: id,
                        name: snapshot.data!["data"]["name"],
                        username: snapshot.data!["data"]["name"])),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
