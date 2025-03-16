import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

abstract class MapLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapLocationInitial extends MapLocationState {}

class MapLocationLoading extends MapLocationState {}

class MapLocationSuccess extends MapLocationState {
  final LocationData locationData;

  MapLocationSuccess(this.locationData);

  @override
  List<Object> get props => [locationData];
}

class MapLocationFailure extends MapLocationState {
  final String errorMessage;

  MapLocationFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class MarkerUpdated extends MapLocationState {
  final LatLng? markerPosition;

  MarkerUpdated(this.markerPosition);

  @override
  List<Object?> get props => [markerPosition];
}

class CurrentLocationChanged extends MapLocationState {
  final LocationData locationData;

  CurrentLocationChanged(this.locationData);

  @override
  List<Object> get props => [locationData];
}

class MapViewUpdated extends MapLocationState {
  final LatLng center;
  final double zoom;

  MapViewUpdated(this.center, this.zoom);

  @override
  List<Object> get props => [center, zoom];
}
