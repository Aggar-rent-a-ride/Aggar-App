import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: context.theme.white100_2,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: user.imagePath == null
            ? Image.asset(
                AppAssets.assetsImagesDafaultPfp0,
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              )
            : Image.network(
                EndPoint.baseUrl + user.imagePath!,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AppAssets.assetsImagesDafaultPfp0,
                    height: 35,
                    width: 35,
                    fit: BoxFit.cover,
                  );
                },
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
