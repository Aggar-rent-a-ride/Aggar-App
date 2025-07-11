import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/settings/presentation/widgets/contact_card_connect_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.white100_1,
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: context.theme.white100_1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.theme.black100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Contact Us',
          style: AppStyles.semiBold24(context)
              .copyWith(color: context.theme.black100),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                'We would love to hear from you!',
                style: AppStyles.bold18(context).copyWith(
                  color: context.theme.blue100_1,
                ),
              ),
              const Gap(8),
              Text(
                'Feel free to reach out to us through any of the following ways. We\'re here to help and will get back to you as soon as possible.',
                style: AppStyles.regular16(context).copyWith(
                  color: context.theme.black100,
                ),
              ),
              const Gap(32),

              // Contact Methods Section
              Text(
                'Get in Touch',
                style: AppStyles.semiBold18(context)
                    .copyWith(color: context.theme.black100),
              ),
              const Gap(16),

              // Email Contact
              ContactCard(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: 'Send us an email',
                value: 'aggarapp@gmail.com',
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
                        await Clipboard.setData(
                            const ClipboardData(text: 'aggarapp@gmail.com'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            context,
                            "Error",
                            'No email client or browser found. Email copied to clipboard!',
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
              const Gap(32),
              Text(
                'Office Hours',
                style: AppStyles.semiBold18(context)
                    .copyWith(color: context.theme.black100),
              ),
              const Gap(16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.theme.blue100_1.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.theme.blue100_1.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: context.theme.blue100_1,
                          size: 20,
                        ),
                        const Gap(8),
                        Text(
                          'We\'re available:',
                          style: AppStyles.semiBold14(context).copyWith(
                            color: context.theme.black100,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      'Monday - Friday: 9:00 AM - 6:00 PM\nSaturday: 10:00 AM - 4:00 PM\nSunday: Closed',
                      style: AppStyles.regular14(context).copyWith(
                        color: context.theme.black100,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
