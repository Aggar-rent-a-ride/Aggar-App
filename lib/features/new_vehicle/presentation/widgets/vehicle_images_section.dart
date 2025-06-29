import 'dart:io';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/edit_vehicle/presentation/cubit/edit_vehicle_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_list_view.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_main_image_button_style.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/main_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleImagesSection extends StatefulWidget {
  const VehicleImagesSection({
    super.key,
    this.initialMainImageUrl,
    required this.initialMainImagesUrl,
  });
  final String? initialMainImageUrl;
  final List<String?> initialMainImagesUrl;

  @override
  _VehicleImagesSectionState createState() => _VehicleImagesSectionState();
}

class _VehicleImagesSectionState extends State<VehicleImagesSection> {
  File? mainImage;

  void onMainImagePicked(File image) {
    setState(() {
      mainImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Images :",
          style: AppStyles.bold22(context).copyWith(
            color: context.theme.blue100_2,
          ),
        ),
        const SizedBox(height: 10),
        PickMainImageButtonContent(
          onImagePicked: (file) {
            context.read<EditVehicleCubit>().setMainImageFile(file);
            onMainImagePicked(file);
          },
          initialImageUrl: widget.initialMainImageUrl,
        ),
        const SizedBox(height: 10),
        Text(
          "additional images",
          style: AppStyles.medium18(context).copyWith(
            color: context.theme.blue100_1,
          ),
        ),
        const SizedBox(height: 10),
        AdditionalImageListView(
          mainImage: mainImage,
          initialImagesUrl: widget.initialMainImagesUrl,
        ),
      ],
    );
  }
}

class PickMainImageButtonContent extends StatefulWidget {
  final Function(File) onImagePicked;
  final String? initialImageUrl;

  const PickMainImageButtonContent({
    super.key,
    required this.onImagePicked,
    this.initialImageUrl,
  });

  @override
  State<PickMainImageButtonContent> createState() =>
      _PickMainImageButtonContentState();
}

class _PickMainImageButtonContentState
    extends State<PickMainImageButtonContent> {
  @override
  void initState() {
    super.initState();
    if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      final cubit = context.read<MainImageCubit>();
      cubit.setImageUrl(widget.initialImageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainImageCubit, MainImageState>(
      builder: (context, state) {
        return FormField<File>(
          validator: (file) {
            if (state is MainImageInitial || state is MainImageFaliure) {
              return "Please select a main image";
            }
            if (state is MainImageLoaded) {
              if (!state.hasImage) {
                return "Please select a main image";
              }
            }
            return null;
          },
          initialValue: state is MainImageLoaded ? state.imageFile : null,
          builder: (FormFieldState<File> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: field.hasError
                        ? Border.all(color: context.theme.red100_1)
                        : null,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _buildImageContent(state, field, context),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                    child: Text(
                      field.errorText!,
                      style: AppStyles.regular14(context).copyWith(
                        color: context.theme.red100_1,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildImageContent(
      MainImageState state, FormFieldState<File> field, BuildContext context) {
    if (state is MainImageInitial || state is MainImageFaliure) {
      return PickMainImageButtonStyle(
        onPressed: () => _pickImage(field, context),
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage(AppAssets.assetsIconsPickimage),
              height: MediaQuery.of(context).size.width * 0.1,
            ),
            Text(
              "click here to pick \nmain image ",
              textAlign: TextAlign.center,
              style: AppStyles.regular16(context).copyWith(
                color: context.theme.blue100_1,
              ),
            ),
          ],
        ),
      );
    } else if (state is MainImageLoaded) {
      return GestureDetector(
        onTap: () => _pickImage(field, context),
        child: state.imageFile != null
            ? MainImageCard(
                image: state.imageFile!,
                onRemove: () {
                  context.read<MainImageCubit>().reset();
                  field.didChange(null);
                },
              )
            : state.imageUrl != null && state.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      state.imageUrl!.startsWith('http')
                          ? state.imageUrl!
                          : "https://aggarapi.runasp.net${state.imageUrl!}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.5,
                      errorBuilder: (context, error, stackTrace) {
                        return PickMainImageButtonStyle(
                          onPressed: () => _pickImage(field, context),
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage(
                                    AppAssets.assetsIconsPickimage),
                                height: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Text(
                                "Failed to load image\nClick to pick again",
                                textAlign: TextAlign.center,
                                style: AppStyles.regular16(context).copyWith(
                                  color: context.theme.blue100_1,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : PickMainImageButtonStyle(
                    onPressed: () => _pickImage(field, context),
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image:
                              const AssetImage(AppAssets.assetsIconsPickimage),
                          height: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Text(
                          "click here to pick \nmain image ",
                          textAlign: TextAlign.center,
                          style: AppStyles.regular16(context).copyWith(
                            color: context.theme.blue100_1,
                          ),
                        ),
                      ],
                    ),
                  ),
      );
    }
    return Container();
  }

  void _pickImage(FormFieldState<File> field, BuildContext context) {
    context.read<MainImageCubit>().pickImage((File file) {
      widget.onImagePicked(file);
      field.didChange(file);
    });
  }
}
