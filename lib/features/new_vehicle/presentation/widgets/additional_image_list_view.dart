import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_cubit.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_button.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/additional_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aggar/features/new_vehicle/presentation/widgets/add_image_button.dart';

class AdditionalImageListView extends StatefulWidget {
  const AdditionalImageListView({super.key});

  @override
  State<AdditionalImageListView> createState() =>
      _AdditionalImageListViewState();
}

class _AdditionalImageListViewState extends State<AdditionalImageListView> {
  @override
  void initState() {
    super.initState();
    context.read<AdditionalImageCubit>().initializeImages();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: BlocBuilder<AdditionalImageCubit, AdditionalImageState>(
        builder: (context, state) {
          if (state is AdditionalImagesInitial ||
              state is AdditionalImagesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdditionalImagesLoaded) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.images.length,
              itemBuilder: (context, index) => Row(
                children: [
                  index == 0 ? const AdditionalImageButton() : const SizedBox(),
                  state.images[index] == null
                      ? AddImageButton(
                          onPressed: () {
                            context
                                .read<AdditionalImageCubit>()
                                .pickImage(index);
                          },
                        )
                      : AdditionalImageCard(image: state.images[index]!),
                ],
              ),
            );
          } else if (state is AdditionalImagesFailure) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
