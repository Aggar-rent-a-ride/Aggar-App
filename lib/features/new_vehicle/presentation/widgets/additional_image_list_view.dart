import 'dart:io';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/add_image_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card.dart';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdditionalImageListView extends StatefulWidget {
  final File? mainImage;
  final List<String?> initialImagesUrl;
  const AdditionalImageListView({
    super.key,
    this.mainImage,
    required this.initialImagesUrl,
  });

  @override
  State<AdditionalImageListView> createState() =>
      _AdditionalImageListViewState();
}

class _AdditionalImageListViewState extends State<AdditionalImageListView> {
  List<String?> _cachedImagesUrl = [];

  @override
  void initState() {
    super.initState();
    _cachedImagesUrl = List<String?>.from(widget.initialImagesUrl);
    context.read<AdditionalImageCubit>().initializeImages(widget.mainImage);
    _setInitialImagesUrl();
  }

  void _setInitialImagesUrl() {
    if (_cachedImagesUrl.isNotEmpty) {
      for (int i = 0; i < _cachedImagesUrl.length; i++) {
        if (_cachedImagesUrl[i] != null && _cachedImagesUrl[i]!.isNotEmpty) {
          context
              .read<AdditionalImageCubit>()
              .setImagesUrl(_cachedImagesUrl[i]!, i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdditionalImageCubit, AdditionalImageState>(
      listener: (context, state) {
        if (state is AdditionalImagesFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              context,
              "Error",
              "Unexpected error occurred!",
              SnackBarType.error,
            ),
          );
        }
      },
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.03 + 50,
        width: double.infinity,
        child: BlocBuilder<AdditionalImageCubit, AdditionalImageState>(
          buildWhen: (previous, current) {
            return current is AdditionalImagesLoaded ||
                current is AdditionalImagesLoading ||
                current is AdditionalImagesFailure;
          },
          builder: (context, state) {
            if (state is AdditionalImagesLoaded) {
              final localImages = state.images;
              final initialImagesCount = _cachedImagesUrl
                  .where((url) => url != null && url.isNotEmpty)
                  .length;
              final totalItems = initialImagesCount + localImages.length + 1;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: totalItems,
                itemBuilder: (context, index) {
                  if (index < initialImagesCount) {
                    final url = _cachedImagesUrl.elementAtOrNull(index);
                    if (url != null && url.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: NetworkImageCard(
                          imageUrl: url,
                          onRemove: () {
                            final cubit = context.read<AdditionalImageCubit>();
                            cubit.removeImageUrl(url);
                            setState(() {
                              _cachedImagesUrl.removeAt(index);
                            });
                          },
                        ),
                      );
                    }
                  }

                  final localIndex = index - initialImagesCount;
                  if (localIndex >= 0 && localIndex < localImages.length) {
                    final file = localImages[localIndex];
                    if (file != null) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: AdditionalImageCard(
                          image: file,
                          onRemove: () {
                            context
                                .read<AdditionalImageCubit>()
                                .removeImageAt(localIndex);
                            setState(() {});
                          },
                        ),
                      );
                    }
                  }

                  if (index == totalItems - 1) {
                    return AddImageButton(
                      onPressed: () {
                        context
                            .read<AdditionalImageCubit>()
                            .pickImage(localImages.length);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            }
            if (state is AdditionalImagesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AdditionalImagesFailure) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

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
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl.startsWith('http')
                  ? imageUrl
                  : "https://aggarapi.runasp.net$imageUrl",
              fit: BoxFit.cover,
              width: 100,
              height: 100,
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
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: context.theme.red100_1,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: context.theme.white100_1,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
