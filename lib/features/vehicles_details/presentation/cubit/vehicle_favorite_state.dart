import 'package:equatable/equatable.dart';

abstract class VehicleFavoriteState extends Equatable {
  final bool isFavorite;

  const VehicleFavoriteState({
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [isFavorite];
}

class VehicleFavoriteInitial extends VehicleFavoriteState {
  const VehicleFavoriteInitial({super.isFavorite});
}

class XVehicleFavoriteLoading extends VehicleFavoriteState {
  const XVehicleFavoriteLoading({required super.isFavorite});
}

class VehicleFavoriteSuccess extends VehicleFavoriteState {
  final dynamic response;

  const VehicleFavoriteSuccess(this.response, {required super.isFavorite});

  @override
  List<Object?> get props => [response, isFavorite];
}

class VehicleFavoriteFailure extends VehicleFavoriteState {
  final String errorMessage;

  const VehicleFavoriteFailure(this.errorMessage, {required super.isFavorite});

  @override
  List<Object?> get props => [errorMessage, isFavorite];
}
