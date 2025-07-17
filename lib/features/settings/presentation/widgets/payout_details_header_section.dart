import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PayoutDetailsHeaderSection extends StatelessWidget {
  const PayoutDetailsHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.blue100_8,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 55, bottom: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.theme.white100_1,
              size: 21,
            ),
          ),
          const Gap(5),
          Text(
            "Payout Details",
            style: AppStyles.bold20(context).copyWith(
              color: context.theme.white100_1,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
