import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final LocationData currentLocation;
  final List<LatLng> routePoints;
  final List<Marker> markers;

  const MapLoaded(this.currentLocation, this.routePoints, this.markers);

  MapLoaded copyWith({
    LocationData? currentLocation,
    List<LatLng>? routePoints,
    List<Marker>? markers,
  }) {
    return MapLoaded(
      currentLocation ?? this.currentLocation,
      routePoints ?? this.routePoints,
      markers ?? this.markers,
    );
  }

  @override
  List<Object> get props => [currentLocation, routePoints, markers];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}
