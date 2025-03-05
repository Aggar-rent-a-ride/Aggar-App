import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'main_image_state.dart';

class MainImageCubit extends Cubit<MainImageState> {
  MainImageCubit() : super(MainImageInitial());

  Future<void> pickImage(Function(File) onImagePicked) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      onImagePicked(image);
      emit(MainImageLoaded(image));
    } else {
      emit(const MainImageFaliure('Failed to pick image'));
    }
  }
}
