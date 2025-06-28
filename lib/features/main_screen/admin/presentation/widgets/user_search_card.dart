import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/options_button.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/user_image.dart';
import 'package:aggar/features/vehicle_details_after_add/presentation/cubit/review_cubit/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/cubit/refresh token/token_refresh_cubit.dart';
import '../../../../profile/presentation/views/show_profile_screen.dart';
import '../../../../vehicle_details_after_add/presentation/cubit/review_count/review_count_cubit.dart';

class UserSearchCard extends StatelessWidget {
  const UserSearchCard({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final tokenCubit = context.read<TokenRefreshCubit>();
        final token = await tokenCubit.getAccessToken();
        if (token != null) {
          context
              .read<UserInfoCubit>()
              .fetchUserInfo(user.id.toString(), token);
          context.read<ReviewCubit>().getUserReviews(user.id.toString(), token);
          context
              .read<ReviewCountCubit>()
              .getUserReviewsNumber(user.id.toString(), token);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowProfileScreen(
                user: user,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: context.theme.black100,
              size: 26,
            ),
            const Gap(5),
            Text(
              user.name,
              style: AppStyles.semiBold18(context).copyWith(
                color: context.theme.black100,
              ),
            ),
            const Gap(5),
            Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                color: context.theme.black100,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const Gap(5),
            Text(
              user.username ?? "",
              style: AppStyles.medium16(context).copyWith(
                color: context.theme.black50,
              ),
            ),
            const Spacer(),
            UserImage(user: user),
            OptionsButton(user: user)
          ],
        ),
      ),
    );
  }
}
