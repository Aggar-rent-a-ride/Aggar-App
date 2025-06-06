import 'package:aggar/core/api/end_points.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/main_screen/admin/model/user_model.dart';
import 'package:aggar/features/main_screen/admin/presentation/widgets/options_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppUserTargetTypeCard extends StatelessWidget {
  const AppUserTargetTypeCard({
    super.key,
    required this.id,
    required this.name,
    this.imagePath,
  });

  final int id;
  final String name;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.blue10_2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      EndPoint.baseUrl + imagePath!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppAssets.assetsImagesDafaultPfp,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      AppAssets.assetsImagesDafaultPfp,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
            const Gap(12),
            Column(
              children: [
                Text(
                  name,
                  style: AppStyles.bold18(context).copyWith(
                    color: context.theme.black100,
                  ),
                ),
              ],
            ),
            const Spacer(),
            OptionsButton(
              user: UserModel(id: id, name: name, username: ""),
            )
          ],
        ),
      ),
    );
  }
}
