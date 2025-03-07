import 'dart:io';

import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdditionalImageCubit extends Cubit<AdditionalImageState> {
  AdditionalImageCubit() : super(AdditionalImagesInitial());
  List<File?> images = [];
  void initializeImages(File? mainImage) {
    emit(AdditionalImagesLoaded([mainImage, null]));
  }

  Future<void> pickImage(int index) async {
    final currentState = state as AdditionalImagesLoaded;
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      images = List<File?>.from(currentState.images);
      images[index] = File(pickedFile.path);
      if (index == images.length - 1) {
        images.add(null);
      }
      emit(AdditionalImagesLoaded(images));
    } else {
      emit(const AdditionalImagesFailure('Failed to pick image'));
    }
  }
}
