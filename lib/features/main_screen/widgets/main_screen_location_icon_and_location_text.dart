import 'package:aggar/core/cubit/user_cubit/user_info_cubit.dart';
import 'package:aggar/core/cubit/user_cubit/user_info_state.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/search/presentation/cubit/search_field/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/app_constants.dart';

class MainScreenLocationIconAndLocationText extends StatelessWidget {
  const MainScreenLocationIconAndLocationText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state is UserInfoSuccess) {
          context.read<SearchCubit>().setLocation(state.userInfoModel.location);
        }
        return Row(
          children: [
            const CustomIcon(
              hight: 20,
              width: 20,
              flag: false,
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
                        ? Row(
                            children: [
                              Text(
                                state.userInfoModel.address,
                                style: AppStyles.medium18(context).copyWith(
                                  color: AppConstants.myWhite100_1
                                      .withOpacity(0.9),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
