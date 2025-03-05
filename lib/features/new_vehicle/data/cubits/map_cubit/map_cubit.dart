import 'package:aggar/core/services/location_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final LocationServices locationServices = LocationServices();

  MapCubit() : super(MapInitial());

  void getCurrentLocation() async {
    emit(MapLoading());
    final locationData = await locationServices.getCurrentLocation();
    if (locationData != null) {
      final markers = [
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(locationData.latitude!, locationData.longitude!),
          child: const Icon(Icons.my_location, color: Colors.blue, size: 40.0),
        ),
      ];
      emit(MapLoaded(locationData, const [], markers));
    } else {
      emit(const MapError('Failed to fetch location'));
    }
  }

  void addDestinationMarker(LatLng point) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final newMarkers = List<Marker>.from(currentState.markers)
        ..add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: point,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
          ),
        );
      emit(currentState.copyWith(markers: newMarkers));
      final routePoints = await locationServices.getRoute(
        LatLng(currentState.currentLocation.latitude!,
            currentState.currentLocation.longitude!),
        point,
      );
      if (routePoints != null) {
        emit(currentState.copyWith(
            routePoints: routePoints, markers: newMarkers));
      } else {
        emit(const MapError('Failed to fetch route'));
      }
    }
  }
}
