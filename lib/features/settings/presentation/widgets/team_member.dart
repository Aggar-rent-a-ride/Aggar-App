import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TeamMember extends StatelessWidget {
  final String name;
  final String role;
  final Color color;
  final String imagePath; // Changed from imageUrl to imagePath

  const TeamMember({
    super.key,
    required this.name,
    required this.role,
    required this.color,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                color: Colors.black12,
                offset: Offset(
                  0,
                  0,
                ),
              )
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            backgroundImage:
                imagePath.isNotEmpty ? AssetImage(imagePath) : null,
            onBackgroundImageError: imagePath.isNotEmpty
                ? (exception, stackTrace) {
                    // Handle image loading error
                  }
                : null,
            child: imagePath.isEmpty
                ? Icon(
                    Icons.person,
                    color: color,
                    size: 28,
                  )
                : null,
          ),
        ),
        const Gap(8),
        Text(
          name,
          style: AppStyles.semiBold14(context).copyWith(
            color: context.theme.black100,
          ),
        ),
        const Gap(2),
        Text(
          role,
          style: AppStyles.regular10(context).copyWith(
            color: context.theme.black100.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
