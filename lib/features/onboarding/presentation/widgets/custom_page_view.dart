import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/app_styles.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView(
      {super.key,
      required this.img,
      required this.title,
      required this.description});
  final String img;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.white100_1,
      child: Column(
        children: [
          Image(
            image: AssetImage(
              img,
            ),
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.fitWidth,
          ),
          const Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bold36(context),
                ),
                const Gap(30),
                Text(
                  description,
                  style: AppStyles.regular20(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
