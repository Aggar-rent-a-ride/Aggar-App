import 'dart:io';
import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_main_image_button_style.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/main_image_card.dart';

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
            if (state is MainImageInitial) {
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
    if (state is MainImageInitial) {
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
            )
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
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Failed to load image"),
                                Text("URL: ${state.imageUrl}",
                                    style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Center(child: Text("No image selected")),
                  ),
      );
    } else if (state is MainImageFaliure) {
      return PickMainImageButtonStyle(
        onPressed: () {
          context.read<MainImageCubit>().reset();
          _pickImage(field, context);
        },
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
            )
          ],
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
