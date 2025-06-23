import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/settings/Data/cubit/logout_cubit.dart';
import 'package:aggar/features/settings/Data/cubit/logout_state.dart';
import 'package:aggar/features/settings/presentation/widgets/arrow_forward_icon_button.dart';
import 'package:aggar/features/settings/presentation/widgets/custom_card_settings_page.dart';
import 'package:aggar/features/authorization/presentation/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/api/dio_consumer.dart';

class LogoutCard extends StatelessWidget {
  const LogoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(
        dioConsumer: DioConsumer(dio: Dio()),
        secureStorage: const FlutterSecureStorage(),
      ),
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInView()),
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                context,
                "Success",
                "Sign out successful!",
                SnackBarType.success,
              ),
            );
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                context,
                "Error",
                "Sign out failed!",
                SnackBarType.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomCardSettingsPage(
            padingHorizental: 5,
            padingVeritical: 10,
            onPressed: state is! LogoutLoading
                ? () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return CustomDialog(
                          title: "Confirm Logout",
                          actionTitle: "Logout",
                          subtitle: "Are you sure you want to log out?",
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            context.read<LogoutCubit>().logout();
                          },
                        );
                      },
                    );
                  }
                : null,
            backgroundColor: context.theme.blue100_7,
            child: Row(
              children: [
                const Image(
                  image: AssetImage(
                    AppAssets.assetsIconsLogout,
                  ),
                  height: 25,
                  width: 25,
                ),
                const Gap(10),
                Text(
                  "Logout",
                  style: AppStyles.bold16(context).copyWith(
                    color: Colors.red,
                  ),
                ),
                const Spacer(),
                state is LogoutLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ))
                    : const ArrowForwardIconButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
