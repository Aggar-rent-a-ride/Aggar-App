import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'main_image_state.dart';

class MainImageCubit extends Cubit<MainImageState> {
  MainImageCubit() : super(MainImageInitial());
  File? image;
  String? imageUrl;

  void updateImage(File file) {
    image = file;
    emit(MainImageLoaded(imageFile: file));
  }

  void reset() {
    emit(MainImageInitial());
  }

  void setImageUrl(String url) {
    imageUrl = url;
    emit(MainImageLoaded(imageUrl: url));
  }

  Future<void> pickImage(Function(File) onImagePicked) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      onImagePicked(image!);
      emit(MainImageLoaded(imageFile: image!));
    } else {
      emit(const MainImageFaliure('Failed to pick imaggggggggge'));
    }
  }
}
