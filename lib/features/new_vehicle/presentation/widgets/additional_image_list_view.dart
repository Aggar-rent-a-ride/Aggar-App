import 'dart:io';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/add_image_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/network_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdditionalImageListView extends StatefulWidget {
  final File? mainImage;
  final List<String?> initialImagesUrl;
  const AdditionalImageListView(
      {super.key, this.mainImage, required this.initialImagesUrl});

  @override
  State<AdditionalImageListView> createState() =>
      _AdditionalImageListViewState();
}

class _AdditionalImageListViewState extends State<AdditionalImageListView> {
  @override
  void initState() {
    super.initState();
    context.read<AdditionalImageCubit>().initializeImages(widget.mainImage);
    if (widget.initialImagesUrl.isNotEmpty) {
      for (int i = 0; i < widget.initialImagesUrl.length; i++) {
        if (widget.initialImagesUrl[i] != null &&
            widget.initialImagesUrl[i]!.isNotEmpty) {
          context
              .read<AdditionalImageCubit>()
              .setImagesUrl(widget.initialImagesUrl[i]!, i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: BlocBuilder<AdditionalImageCubit, AdditionalImageState>(
        builder: (context, state) {
          if (state is AdditionalImagesLoaded) {
            final localImages = state.images;

            // Calculate total items
            final initialImagesCount = widget.initialImagesUrl
                .where((url) => url != null && url.isNotEmpty)
                .length;
            final totalItems = initialImagesCount +
                localImages.length +
                1; // +1 for AddImageButton

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: totalItems,
              itemBuilder: (context, index) {
                // Display network images first
                if (index < initialImagesCount) {
                  final url = widget.initialImagesUrl[index];
                  if (url != null && url.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: NetworkImageCard(
                        imageUrl: url,
                        onRemove: () {
                          // Handle network image removal if needed
                        },
                      ),
                    );
                  }
                }

                // Display local file images
                final localIndex = index - initialImagesCount;
                if (localIndex >= 0 && localIndex < localImages.length) {
                  final file = localImages[localIndex];
                  if (file != null) {
                    return AdditionalImageCard(
                      image: file,
                      onRemove: () {
                        context
                            .read<AdditionalImageCubit>()
                            .removeImageAt(localIndex);
                      },
                    );
                  }
                }

                // Show Add Image button at the end
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

          // Show loading indicator when images are being loaded
          if (state is AdditionalImagesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error if there's a failure
          if (state is AdditionalImagesFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
