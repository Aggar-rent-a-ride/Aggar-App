import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/settings/presentation/widgets/contact_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class NeedMoreHelpSection extends StatelessWidget {
  const NeedMoreHelpSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Need More Help?',
          style: AppStyles.semiBold18(context)
              .copyWith(color: context.theme.black100),
        ),
        const Gap(16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.theme.blue100_1.withOpacity(0.1),
                context.theme.blue100_1.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.theme.blue100_1.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.theme.blue100_1.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.support_agent_outlined,
                      color: context.theme.blue100_1,
                      size: 24,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Support',
                          style: AppStyles.semiBold16(context).copyWith(
                            color: context.theme.black100,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          'Get personalized help from our support team',
                          style: AppStyles.regular12(context).copyWith(
                            color: context.theme.black100.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: ContactButton(
                      icon: Icons.email_outlined,
                      label: 'Email Us',
                      onTap: () async {
                        final mailtoLink = Mailto(
                          to: ['aggarapp@gmail.com'],
                          subject: 'Contact Us',
                          body: 'Hello!',
                        );

                        try {
                          final mailtoUri = Uri.parse('$mailtoLink');
                          if (await canLaunchUrl(mailtoUri)) {
                            await launchUrl(mailtoUri);
                          } else {
                            // Fallback: Open Gmail in browser
                            final webUri = Uri.parse(
                              'https://mail.google.com/mail/?view=cm&fs=1&to=aggarapp@gmail.com&su=Contact%20Us&body=Hello!',
                            );
                            if (await canLaunchUrl(webUri)) {
                              await launchUrl(webUri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              // Last resort: Copy email to clipboard
                              await Clipboard.setData(const ClipboardData(
                                  text: 'aggarapp@gmail.com'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackBar(
                                  context,
                                  "Error",
                                  "No email client or browser found. Email copied to clipboard!",
                                  SnackBarType.error,
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar(
                              context,
                              "Error",
                              'Error launching email: $e',
                              SnackBarType.error,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
