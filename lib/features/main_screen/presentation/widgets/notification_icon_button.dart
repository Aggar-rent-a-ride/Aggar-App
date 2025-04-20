import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: context.theme.white100_1.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomIcon(
              hight: 0,
              width: 0,
              flag: false,
              imageIcon: AppAssets.assetsIconsNotification,
            ),
          ),
        ),
        Positioned(
          right: 9,
          top: 9,
          child: Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: context.theme.green100_1,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
