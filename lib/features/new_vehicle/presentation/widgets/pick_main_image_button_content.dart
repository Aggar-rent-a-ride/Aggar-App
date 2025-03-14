import 'dart:io';

import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/main_image_cubit/main_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/core/utils/app_assets.dart';
import 'package:aggar/core/utils/app_colors.dart';
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
        if (state is MainImageInitial) {
          return PickMainImageButtonStyle(
            onPressed: () {
              context.read<MainImageCubit>().pickImage(widget.onImagePicked);
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
                    color: AppColors.myBlue100_1,
                  ),
                )
              ],
            ),
          );
        } else if (state is MainImageLoaded) {
          return MainImageCard(image: state.image);
        } else if (state is MainImageFaliure) {
          // TODO : not handle here
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
