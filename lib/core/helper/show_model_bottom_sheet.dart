import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/core/widgets/splet_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<dynamic> customShowModelBottmSheet(
    BuildContext context, String title, Widget widget) {
  return showModalBottomSheet(
    backgroundColor: context.theme.white100_1,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    sheetAnimationStyle: AnimationStyle(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
      reverseDuration: const Duration(milliseconds: 300),
      reverseCurve: Curves.ease,
    ),
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          minHeight: 200,
        ),
        child: IntrinsicHeight(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(10),
                  const SpletContainer(),
                  Text(
                    title,
                    style: AppStyles.bold24(context).copyWith(
                      color: context.theme.blue100_1,
                    ),
                  ),
                  widget,
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
