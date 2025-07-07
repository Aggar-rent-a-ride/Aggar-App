import 'package:aggar/core/cubit/refresh%20token/token_refresh_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/app_constants.dart';

// Text Display Widget
class TextDisplayWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final double maxWidth;

  const TextDisplayWidget({
    super.key,
    required this.text,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final shouldScroll = textPainter.width > maxWidth;

    return shouldScroll
        ? Marquee(
            text: text,
            style: textStyle,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 20.0,
            velocity: 50.0,
            pauseAfterRound: const Duration(seconds: 1),
            startPadding: 0.0,
            accelerationDuration: const Duration(milliseconds: 500),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.linear,
          )
        : Text(
            text,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          );
  }
}

class MainScreenLocationIconAndLocationText extends StatefulWidget {
  const MainScreenLocationIconAndLocationText({
    super.key,
  });

  @override
  State<MainScreenLocationIconAndLocationText> createState() =>
      _MainScreenLocationIconAndLocationTextState();
}

class _MainScreenLocationIconAndLocationTextState
    extends State<MainScreenLocationIconAndLocationText> {
  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final tokenCubit = context.read<TokenRefreshCubit>();
    final token = await tokenCubit.getAccessToken();
    if (token != null && mounted) {
      const secureStorage = FlutterSecureStorage();
      String? userIdStr = await secureStorage.read(key: 'userId');
      int? userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId != null && userId > 0 && mounted) {
        context.read<UserInfoCubit>().fetchUserInfo(userId.toString(), token);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoSuccess) {
          context.read<SearchCubit>().setLocation(state.userInfoModel.location);
        }
        return Row(
          children: [
            CustomIcon(
              hight: 20,
              width: 20,
              flag: false,
              color: context.theme.black50,
              imageIcon: AppAssets.assetsIconsLocation,
            ),
            const Gap(5),
            state is UserInfoLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.white12,
                    highlightColor: context.theme.blue100_5,
                    child: Container(
                      width: 120,
                      height: 20,
                      decoration: BoxDecoration(
                        color: context.theme.black100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  )
                : state is UserInfoError
                    ? Text(
                        'Failed to load location',
                        style: AppStyles.medium18(context).copyWith(
                          color: AppConstants.myWhite100_1.withOpacity(0.9),
                        ),
                      )
                    : state is UserInfoSuccess
                        ? SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            height: 20,
                            child: TextDisplayWidget(
                              text: state.userInfoModel.address ?? "",
                              textStyle: AppStyles.medium18(context).copyWith(
                                color:
                                    AppConstants.myWhite100_1.withOpacity(0.9),
                              ),
                              maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                            ),
                          )
                        : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
