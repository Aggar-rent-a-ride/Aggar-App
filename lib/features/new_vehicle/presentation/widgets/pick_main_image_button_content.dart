import 'dart:io';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/themes/app_light_colors.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/pick_main_image_button_style.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/main_image_card.dart';

class PickMainImageButtonContent extends StatefulWidget {
  final Function(File) onImagePicked;
  const PickMainImageButtonContent({super.key, required this.onImagePicked});
  @override
  State<PickMainImageButtonContent> createState() =>
      _PickMainImageButtonContentState();
}

class _PickMainImageButtonContentState
    extends State<PickMainImageButtonContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainImageCubit, MainImageState>(
      builder: (context, state) {
        return FormField<File>(
          validator: (file) {
            if (state is MainImageInitial || file == null) {
              return "Please select a main image";
            }
            return null;
          },
          initialValue: state is MainImageLoaded ? state.image : null,
          builder: (FormFieldState<File> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: field.hasError
                        ? Border.all(
                            color: AppLightColors.myRed100_1,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: state is MainImageInitial
                      ? PickMainImageButtonStyle(
                          onPressed: () {
                            context
                                .read<MainImageCubit>()
                                .pickImage((File file) {
                              widget.onImagePicked(file);
                              field.didChange(file);
                            });
                          },
                          widget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: const AssetImage(
                                  AppAssets.assetsIconsPickimage,
                                ),
                                height: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "click here to pick \nmain image ",
                                style: AppStyles.regular16(context).copyWith(
                                  color: AppLightColors.myBlue100_1,
                                ),
                              )
                            ],
                          ),
                        )
                      : state is MainImageLoaded
                          ? GestureDetector(
                              onTap: () {
                                context
                                    .read<MainImageCubit>()
                                    .pickImage((File file) {
                                  widget.onImagePicked(file);
                                  field.didChange(file);
                                });
                              },
                              child: MainImageCard(image: state.image),
                            )
                          : state is MainImageFaliure
                              ? Center(child: Text(state.message))
                              : Container(),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                    child: Text(
                      field.errorText!,
                      style: AppStyles.regular14(context).copyWith(
                        color: AppLightColors.myRed100_1,
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
}
