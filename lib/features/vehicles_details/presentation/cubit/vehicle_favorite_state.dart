import 'package:equatable/equatable.dart';

abstract class VehicleFavoriteState extends Equatable {
  final bool isFavorite;

  const VehicleFavoriteState({required this.isFavorite});

  @override
  List<Object?> get props => [isFavorite];
}

class VehicleFavoriteInitial extends VehicleFavoriteState {
  const VehicleFavoriteInitial({required super.isFavorite});
}

class VehicleFavoriteLoading extends VehicleFavoriteState {
  const VehicleFavoriteLoading({required super.isFavorite});
}

class VehicleFavoriteSuccess extends VehicleFavoriteState {
  final dynamic response;

  const VehicleFavoriteSuccess(
      {required this.response, required super.isFavorite});

  @override
  List<Object?> get props => [response, isFavorite];
}

class VehicleFavoriteFailure extends VehicleFavoriteState {
  final String errorMessage;

  const VehicleFavoriteFailure(this.errorMessage, {required super.isFavorite});

  @override
  List<Object?> get props => [errorMessage, isFavorite];
}
