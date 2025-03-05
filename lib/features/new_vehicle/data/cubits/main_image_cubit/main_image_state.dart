import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class MainImageState extends Equatable {
  const MainImageState();

  @override
  List<Object?> get props => [];
}

class MainImageInitial extends MainImageState {}

class MainImageLoading extends MainImageState {}

class MainImageLoaded extends MainImageState {
  final File image;

  const MainImageLoaded(this.image);

  @override
  List<Object?> get props => [image];
}

class MainImageFaliure extends MainImageState {
  final String message;

  const MainImageFaliure(this.message);

  @override
  List<Object?> get props => [message];
}
