import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';

class AdditionalImageCubit extends Cubit<AdditionalImageState> {
  List<File?> images = [];
  List<String?> imagesUrl = []; // Keep this for network images

  AdditionalImageCubit() : super(AdditionalImagesInitial());

  void initializeImages(File? mainImage) {
    // Initialize with empty list
    images = [];
    if (mainImage != null) {
      // You might want to add the main image
      // images.add(mainImage);
    }
    emit(AdditionalImagesLoaded(images));
  }

  void setImagesUrl(String url, int index) {
    // This is for handling network images, keep it as is
    if (index >= 0 && index < imagesUrl.length) {
      imagesUrl[index] = url;
    }
  }

  Future<void> pickImage(int index) async {
    emit(AdditionalImagesLoading());

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);

        // Add the new image
        images.add(imageFile);

        emit(AdditionalImagesLoaded(images));
      } else {
        // User canceled the picker
        emit(AdditionalImagesLoaded(images));
      }
    } catch (e) {
      emit(AdditionalImagesFailure(e.toString()));
    }
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      emit(AdditionalImagesLoaded(images));
    }
  }
}
