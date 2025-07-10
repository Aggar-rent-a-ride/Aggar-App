import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/settings/presentation/widgets/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ConnectWithUs extends StatelessWidget {
  const ConnectWithUs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Follow us for updates and tips',
          style: AppStyles.regular14(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        const Gap(12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SocialIcon(
              icon: Iconsax.global,
              label: 'GitHub',
              imageList: [
                AppAssets.assetsImagesEsraa,
                AppAssets.assetsImagesAli,
                AppAssets.assetsImagesOmar,
                AppAssets.assetsImagesMohamed,
              ],
              linkList: [
                "https://github.com/esraaehab333",
                "https://github.com/Al-Dos024",
                "https://github.com/OmarNaru1110",
                "https://github.com/mohamed-said03",
              ],
              nameList: [
                "Esraa Ehab",
                "Ali Dosoqi",
                "Omar Elnaggar",
                "Mohamed Said",
              ],
            ),
            SocialIcon(
              icon: Icons.alternate_email,
              label: 'G-mail',
              imageList: [
                AppAssets.assetsImagesEsraa,
                AppAssets.assetsImagesAli,
                AppAssets.assetsImagesOmar,
                AppAssets.assetsImagesMohamed,
              ],
              linkList: [
                "esraaehabb333@gmail.com",
                "amjdos0190edu@gmail.com",
                "omarnaru2002@gmail.com",
                "mohamedsaid3403@gmail.com",
              ],
              nameList: [
                "Esraa Ehab",
                "Ali Dosoqi",
                "Omar Elnaggar",
                "Mohamed Said",
              ],
            ),
            SocialIcon(
              icon: Icons.business_center,
              label: 'LinkedIn',
              imageList: [
                AppAssets.assetsImagesEsraa,
                AppAssets.assetsImagesAli,
                AppAssets.assetsImagesOmar,
                AppAssets.assetsImagesMohamed,
              ],
              linkList: [
                "https://www.linkedin.com/in/esraa-ehab-b2b190268/",
                "https://www.linkedin.com/in/ali-dosoqi/",
                "https://www.linkedin.com/in/omarnaru/",
                "https://www.linkedin.com/in/mohamed-said03/",
              ],
              nameList: [
                "Esraa Ehab",
                "Ali Dosoqi",
                "Omar Elnaggar",
                "Mohamed Said",
              ],
            ),
            SocialIcon(
              icon: Icons.web, // Fixed: Changed from Icons.prtfol to Icons.web
              label: 'Portfolio',
              imageList: [
                AppAssets.assetsImagesOmar,
              ],
              linkList: [
                "https://omarelnaggar.vercel.app/",
              ],
              nameList: ["Omar Elnaggar"],
            ),
          ],
        ),
      ],
    );
  }
}
