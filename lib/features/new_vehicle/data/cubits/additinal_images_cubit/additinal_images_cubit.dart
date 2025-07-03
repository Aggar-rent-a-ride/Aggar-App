import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aggar/features/new_vehicle/data/cubits/additinal_images_cubit/additinal_images_state.dart';

class AdditionalImageCubit extends Cubit<AdditionalImageState> {
  List<File?> images = [];
  List<String?> imagesUrl = [];
  List<String> removedImagesUrls = [];

  AdditionalImageCubit() : super(AdditionalImagesInitial());

  void initializeImages(File? mainImage) {
    images = [];
    imagesUrl = [];
    removedImagesUrls = [];
    emit(AdditionalImagesLoaded(images));
  }

  void setImagesUrl(String url, int index) {
    while (imagesUrl.length <= index) {
      imagesUrl.add(null);
    }
    imagesUrl[index] = url;
  }

  void removeImageUrl(String url) {
    print('Removing image URL: $url');
    removedImagesUrls.add(url);
    imagesUrl.remove(url);
    emit(AdditionalImagesLoaded(images));
  }

  Future<void> pickImage(int index) async {
    emit(AdditionalImagesLoading());

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        images.add(imageFile);

        emit(AdditionalImagesLoaded(images));
      } else {
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

  void reset() {
    images = [];
    imagesUrl = [];
    emit(AdditionalImagesInitial());
  }
}
