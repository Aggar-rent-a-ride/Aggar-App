import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'additinal_images_state.dart';

class AdditionalImageCubit extends Cubit<AdditionalImageState> {
  AdditionalImageCubit() : super(AdditionalImagesInitial());

  List<File?> images = [];
  List<String?> imagesUrl = [];

  void initializeImages(File? mainImage) {
    images = [mainImage, null];
    emit(AdditionalImagesLoaded(images));
  }

  Future<void> pickImage(int index) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Create a new list to avoid mutation issues
        images = List.from(images);
        images[index] = File(pickedFile.path);

        // Add a new null slot if we're filling the last position
        if (index == images.length - 1) {
          images.add(null);
        }

        emit(AdditionalImagesLoaded(images));
      }
    } catch (e) {
      emit(AdditionalImagesFailure('Failed to pick image: ${e.toString()}'));
    }
  }

  void setImagesUrl(String url, int index) {
    if (url.isNotEmpty) {
      // Ensure imagesUrl is large enough
      while (imagesUrl.length <= index) {
        imagesUrl.add(null);
      }

      imagesUrl[index] = url;
      emit(AdditionalImagesLoaded(images));
    }
  }

  void addImage(File file) {
    images.add(file);
    emit(AdditionalImagesLoaded(images));
  }

  void removeImageAt(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);

      // Also remove corresponding URL if it exists
      if (index < imagesUrl.length) {
        imagesUrl.removeAt(index);
      }

      emit(AdditionalImagesLoaded(images));
    }
  }

  void reset() {
    images.clear();
    imagesUrl.clear();
    emit(AdditionalImagesInitial());
  }
}
