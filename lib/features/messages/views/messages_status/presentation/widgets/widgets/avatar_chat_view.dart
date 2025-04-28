import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class AvatarChatView extends StatelessWidget {
  const AvatarChatView({
    super.key,
    this.image,
  });
  final String? image;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
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
                AppAssets.assetsImagesDafaultPfp,
                height: 50,
                width: 50,
              )
            : Image.network(
                "${EndPoint.baseUrl}$image",
                height: 50,
                width: 50,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint("Error loading avatar image: $error");
                  return Image.asset(
                    AppAssets.assetsImagesDafaultPfp,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}
