import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'map_location_state.dart';

class MapLocationCubit extends Cubit<MapLocationState> {
  MapLocationCubit() : super(MapLocationInitial()) {
    _getCurrentLocation();
  }

  final MapController mapController = MapController();
  final Location _location = Location();
  LocationData? currentLocation;
  LatLng? markerPosition;
  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> _getCurrentLocation() async {
    emit(MapLocationLoading());
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          emit(MapLocationFailure('Location services are disabled'));
          return;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          emit(MapLocationFailure('Location permission not granted'));
          return;
        }
      }

      var userLocation = await _location.getLocation();
      currentLocation = userLocation;
      markerPosition = LatLng(
        userLocation.latitude!,
        userLocation.longitude!,
      );

      emit(MapLocationSuccess(userLocation));
      emit(MarkerUpdated(markerPosition));
      _locationSubscription =
          _location.onLocationChanged.listen((LocationData newLocation) {
        if (isClosed) return;
        currentLocation = newLocation;
        emit(CurrentLocationChanged(newLocation));
      });
    } catch (e) {
      emit(MapLocationFailure('Failed to get location: ${e.toString()}'));
    }
  }

  void setSingleMarker(LatLng point) {
    markerPosition = point;
    emit(MarkerUpdated(markerPosition));
  }

  void showCurrentLocation() {
    if (currentLocation != null) {
      final userLatLng = LatLng(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
      );
      markerPosition = userLatLng;
      mapController.move(userLatLng, 16.0);
      emit(MarkerUpdated(markerPosition));
      emit(MapViewUpdated(userLatLng, 16.0));
    }
  }

  String? getMarkerLatitude() {
    return markerPosition?.latitude.toStringAsFixed(6);
  }

  String? getMarkerLongitude() {
    return markerPosition?.longitude.toStringAsFixed(6);
  }

  bool hasMarker() {
    return markerPosition != null;
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
