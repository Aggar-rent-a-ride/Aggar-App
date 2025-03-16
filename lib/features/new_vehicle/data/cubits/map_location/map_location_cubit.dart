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

  Future<void> _getCurrentLocation() async {
    emit(MapLocationLoading());

    try {
      var userLocation = await _location.getLocation();
      currentLocation = userLocation;
      emit(MapLocationSuccess(userLocation));
      _location.onLocationChanged.listen((LocationData newLocation) {
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
    return markerPosition?.latitude.toString();
  }

  String? getMarkerLongitude() {
    return markerPosition?.longitude.toString();
  }

  bool hasMarker() {
    return markerPosition != null;
  }
}
