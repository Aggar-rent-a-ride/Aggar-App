import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class AvatarChatView extends StatelessWidget {
  const AvatarChatView({
    super.key,
    this.image,
    this.size,
  });
  final String? image;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(150),
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.grey100_1,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 4,
            )
          ],
        ),
        child: image == null
            ? Image.asset(
                color: context.theme.black50,
                AppAssets.assetsImagesDafaultPfp0,
                height: size ?? 50,
                width: size ?? 50,
                fit: BoxFit.cover,
              )
            : Image.network(
                // image!,
                "${EndPoint.baseUrl}$image",
                height: size ?? 50,
                width: size ?? 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint("Error loading avatar image: $error");
                  return Image.asset(
                    AppAssets.assetsImagesDafaultPfp0,
                    height: size ?? 50,
                    width: size ?? 50,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}
