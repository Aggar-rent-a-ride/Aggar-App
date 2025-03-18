import 'package:equatable/equatable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

abstract class MapLocationState extends Equatable {
  const MapLocationState();

  @override
  List<Object?> get props => [];
}

class MapLocationInitial extends MapLocationState {}

class MapLocationLoading extends MapLocationState {}

class MapLocationInitialized extends MapLocationState {
  final LatLng? selectedLocation;
  final List<Marker> markers;
  final String selectedAddress;
  final bool isAddressLoading;

  const MapLocationInitialized({
    required this.selectedLocation,
    required this.markers,
    required this.selectedAddress,
    required this.isAddressLoading,
  });

  @override
  List<Object?> get props => [
        selectedLocation,
        markers,
        selectedAddress,
        isAddressLoading,
      ];
}

class MapLocationUpdating extends MapLocationState {
  final LatLng? selectedLocation;
  final List<Marker> markers;
  final String selectedAddress;
  final bool isAddressLoading;

  const MapLocationUpdating({
    required this.selectedLocation,
    required this.markers,
    required this.selectedAddress,
    required this.isAddressLoading,
  });

  @override
  List<Object?> get props => [
        selectedLocation,
        markers,
        selectedAddress,
        isAddressLoading,
      ];
}

class MapLocationUpdated extends MapLocationState {
  final LatLng? selectedLocation;
  final List<Marker> markers;
  final String selectedAddress;
  final bool isAddressLoading;

  const MapLocationUpdated({
    required this.selectedLocation,
    required this.markers,
    required this.selectedAddress,
    required this.isAddressLoading,
  });

  @override
  List<Object?> get props => [
        selectedLocation,
        markers,
        selectedAddress,
        isAddressLoading,
      ];
}

class MapLocationError extends MapLocationState {
  final String error;
  final LatLng? selectedLocation;
  final List<Marker> markers;
  final String selectedAddress;
  final bool isAddressLoading;

  const MapLocationError({
    required this.error,
    required this.selectedLocation,
    required this.markers,
    required this.selectedAddress,
    required this.isAddressLoading,
  });

  @override
  List<Object?> get props => [
        error,
        selectedLocation,
        markers,
        selectedAddress,
        isAddressLoading,
      ];
}
