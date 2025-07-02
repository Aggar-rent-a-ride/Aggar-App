import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/widgets/custom_icon.dart';
import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  const FilterIcon({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.12,
      height: MediaQuery.of(context).size.width * 0.12,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.black50.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const CustomIcon(
            hight: 20,
            width: 20,
            flag: false,
            imageIcon: AppAssets.assetsIconsSort,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
