import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import

class SocialIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> linkList;
  final List<String> nameList;
  final List<String> imageList; // Now expects asset paths

  const SocialIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.linkList,
    required this.nameList,
    required this.imageList,
  });

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Opens in external browser/app
        );
      } else {
        // Handle case where URL cannot be launched
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      // Handle any errors
      debugPrint('Error launching URL: $e');
    }
  }

  void _showMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.theme.white100_1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                nameList.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          index < imageList.length &&
                                  imageList[index].isNotEmpty
                              ? imageList[index]
                              : "assets/images/default_avatar.png", // Default asset image
                        ),
                        onBackgroundImageError: (exception, stackTrace) {
                          // Handle image loading error
                        },
                        child: index < imageList.length &&
                                imageList[index].isNotEmpty
                            ? null
                            : Icon(
                                Icons.person,
                                color: context.theme.black50,
                                size: 20,
                              ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameList[index],
                              style: AppStyles.semiBold14(context).copyWith(
                                color: context.theme.black100,
                              ),
                            ),
                            if (index < linkList.length &&
                                linkList[index].isNotEmpty)
                              InkWell(
                                onTap: () => _launchUrl(linkList[index]),
                                child: Text(
                                  linkList[index],
                                  style: AppStyles.regular12(context).copyWith(
                                    color: context.theme.blue100_1,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: AppStyles.semiBold14(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showMemberDialog(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: context.theme.blue100_1.withOpacity(0.1),
              child: Icon(
                icon,
                color: context.theme.blue100_1,
                size: 18,
              ),
            ),
            const Gap(4),
            Text(
              label,
              style: AppStyles.regular10(context).copyWith(
                color: context.theme.black100.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
