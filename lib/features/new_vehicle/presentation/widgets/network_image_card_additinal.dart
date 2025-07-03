import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkImageCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;

  const NetworkImageCard({
    super.key,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: context.theme.black25,
                offset: const Offset(0, 0),
                blurRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl.startsWith('http')
                  ? imageUrl
                  : "https://aggarapi.runasp.net$imageUrl",
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).height * 0.03 + 50,
              height: MediaQuery.sizeOf(context).height * 0.03 + 50,
              errorBuilder: (context, error, stackTrace) {
                return GestureDetector(
                  onTap: () {
                    context.read<AdditionalImageCubit>().pickImage(
                        context.read<AdditionalImageCubit>().images.length);
                  },
                  child: Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage(AppAssets.assetsIconsPickimage),
                          height: 30,
                        ),
                        Text(
                          "Pick Image",
                          textAlign: TextAlign.center,
                          style: AppStyles.regular12(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: 2,
          child: IconButton(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.black50.withOpacity(0.6),
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: context.theme.white100_1,
              ),
            ),
            onPressed: onRemove,
          ),
        ),
      ],
    );
  }
}
