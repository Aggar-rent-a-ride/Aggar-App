import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/settings/presentation/widgets/connect_with_us.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConnectWithUsSection extends StatelessWidget {
  const ConnectWithUsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect with Us',
          style: AppStyles.semiBold18(context)
              .copyWith(color: context.theme.black100),
        ),
        const Gap(16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.white100_1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.theme.blue100_1.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const ConnectWithUs(),
        ),
      ],
    );
  }
}
