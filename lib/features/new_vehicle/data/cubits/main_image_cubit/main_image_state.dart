import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class MainImageState extends Equatable {
  const MainImageState();

  @override
  List<Object?> get props => [];
}

class MainImageInitial extends MainImageState {}

class MainImageLoading extends MainImageState {}

// In main_image_state.dart, make sure your MainImageLoaded state looks like this:
class MainImageLoaded extends MainImageState {
  final File? imageFile;
  final String? imageUrl;

  const MainImageLoaded({this.imageFile, this.imageUrl});

  bool get hasImage =>
      imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty);

  @override
  List<Object?> get props => [imageFile, imageUrl];
}

class MainImageFaliure extends MainImageState {
  final String message;

  const MainImageFaliure(this.message);

  @override
  List<Object?> get props => [message];
}
