import 'dart:io';
import 'package:aggar/core/helper/custom_snack_bar.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/add_image_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card.dart';
import 'package:aggar/core/widgets/custom_dialog.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/network_image_card_additinal.dart';
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
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                title: "Remove Image",
                                actionTitle: "Remove",
                                subtitle:
                                    'Are you sure you want to remove this image?',
                                onPressed: () {
                                  Navigator.pop(context);
                                  final cubit =
                                      context.read<AdditionalImageCubit>();
                                  cubit.removeImageUrl(url);
                                  setState(() {
                                    _cachedImagesUrl.removeAt(index);
                                  });
                                },
                              ),
                            );
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
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                title: "Remove Image",
                                actionTitle: "Remove",
                                subtitle:
                                    'Are you sure you want to remove this image?',
                                onPressed: () {
                                  Navigator.pop(context);
                                  context
                                      .read<AdditionalImageCubit>()
                                      .removeImageAt(localIndex);
                                  setState(() {});
                                },
                              ),
                            );
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
