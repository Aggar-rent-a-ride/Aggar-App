import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/options_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PersonImageWithName extends StatelessWidget {
  const PersonImageWithName({
    super.key,
    required this.imagePath,
    required this.name,
    required this.id,
  });

  final String? imagePath;
  final String? name;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: imagePath != null
                ? CachedNetworkImage(
                    imageUrl: EndPoint.baseUrl + imagePath!,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      AppAssets.assetsImagesDafaultPfp,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    AppAssets.assetsImagesDafaultPfp,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
          ),
          const Gap(8),
          Flexible(
            child: Text(
              name ?? 'Unknown',
              style: AppStyles.medium14(context).copyWith(
                color: context.theme.black100,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Gap(30),
          OptionsButton(user: UserModel(id: id, name: name ?? "", username: ""))
        ],
      ),
    );
  }
}
