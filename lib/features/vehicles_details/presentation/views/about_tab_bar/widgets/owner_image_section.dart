import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/api/end_points.dart';

class OwnerImageSection extends StatelessWidget {
  const OwnerImageSection({
    super.key,
    this.pfpImage,
  });
  final String? pfpImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: context.theme.black25,
            spreadRadius: 0,
            blurRadius: 4,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: pfpImage == null
            ? Image.asset(
                AppAssets.assetsImagesDafaultPfp0,
                height: 45,
              )
            : Image.network(
                "${EndPoint.baseUrl}$pfpImage",
                height: 45,
              ),
      ),
    );
  }
}
