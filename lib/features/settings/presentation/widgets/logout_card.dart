import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
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
          } else if (state is LogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomCardSettingsPage(
            padingHorizental: 5,
            padingVeritical: 10,
            onPressed: state is! LogoutLoading
                ? () => context.read<LogoutCubit>().logout()
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
