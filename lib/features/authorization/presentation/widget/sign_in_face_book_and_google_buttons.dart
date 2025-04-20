import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:aggar/features/authorization/presentation/widget/sign_in_social_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignInFaceBookAndGoogleButtons extends StatelessWidget {
  const SignInFaceBookAndGoogleButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SignInSocialButton(
          textColor: context.theme.gray100_1,
          icon: const CustomIcon(
            hight: 21,
            width: 21,
            flag: false,
            imageIcon: AppAssets.assetsIconsFacebookIcon,
          ),
          color: Colors.blue,
          text: 'Facebook',
        ),
        const Gap(20),
        SignInSocialButton(
          textColor: context.theme.black100,
          icon: const CustomIcon(
            hight: 21,
            width: 21,
            flag: false,
            imageIcon: AppAssets.assetsIconsGoogleIcon,
          ),
          color: context.theme.gray100_1,
          text: 'Google',
        ),
      ],
    );
  }
}
