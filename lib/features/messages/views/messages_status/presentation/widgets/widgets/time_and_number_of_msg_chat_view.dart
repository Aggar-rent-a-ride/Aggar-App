import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimeAndNumberOfMsgChatView extends StatelessWidget {
  const TimeAndNumberOfMsgChatView({
    super.key,
    required this.time,
    required this.numberMsg,
  });
  final String time;
  final int numberMsg;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          time,
          style: AppStyles.medium14(context).copyWith(
            color: context.theme.black25,
          ),
        ),
        const Gap(6),
        numberMsg == 0
            ? const SizedBox(
                height: 25,
                width: 25,
              )
            : Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: context.theme.blue100_3,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    numberMsg.toString(),
                    style: AppStyles.medium12(context),
                  ),
                ),
              )
      ],
    );
  }
}
