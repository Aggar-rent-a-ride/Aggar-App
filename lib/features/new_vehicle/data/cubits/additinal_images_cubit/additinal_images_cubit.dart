import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';

class AdditionalImageCubit extends Cubit<AdditionalImageState> {
  List<File?> images = [];
  List<String?> imagesUrl = [];
  String? removedImageUrl;

  AdditionalImageCubit() : super(AdditionalImagesInitial());

  void initializeImages(File? mainImage) {
    images = [];
    if (mainImage != null) {}
    emit(AdditionalImagesLoaded(images));
  }

  void setImagesUrl(String url, int index) {
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
