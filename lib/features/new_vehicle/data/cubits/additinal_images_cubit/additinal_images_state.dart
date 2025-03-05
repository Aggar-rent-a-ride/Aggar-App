import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AdditionalImageState extends Equatable {
  const AdditionalImageState();

  @override
  List<Object?> get props => [];
}

class AdditionalImagesInitial extends AdditionalImageState {}

class AdditionalImagesLoading extends AdditionalImageState {}

class AdditionalImagesLoaded extends AdditionalImageState {
  final List<File?> images;

  const AdditionalImagesLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

class AdditionalImagesFailure extends AdditionalImageState {
  final String message;

  const AdditionalImagesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
