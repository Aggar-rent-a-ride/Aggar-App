import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/options_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PersonImageWithName extends StatelessWidget {
  const PersonImageWithName({
    super.key,
    required this.id,
  });

  final int id;

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
                const Gap(8),
                Container(
                  height: 25,
                  width: 120,
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
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  AppAssets.assetsImagesDafaultPfp,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(8),
              Flexible(
                child: Text(
                  snapshot.data!["data"]["name"],
                  style: AppStyles.medium14(context).copyWith(
                    color: context.theme.black100,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Gap(30),
              OptionsButton(
                  user: UserModel(
                      id: id,
                      name: snapshot.data!["data"]["name"],
                      username: snapshot.data!["data"]["name"])),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
